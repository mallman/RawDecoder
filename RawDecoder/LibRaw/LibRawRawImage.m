#import "LibRawRawImage.h"

#import "../RDError+Private.h"

@interface RDCFA ()
- (instancetype) initWithCFAColors:(RDCFAColor *)cfaColors
                             width:(NSInteger)width
                            height:(NSInteger)height;
@end

@interface RDRawImageMetadata ()
- (instancetype)initFromLibrawData:(libraw_data_t *)librawData
                          exifMake:(NSString * _Nullable)exifMake
                         exifModel:(NSString * _Nullable)exifModel;
@end

RDCFAColor libRawImageColorWithLibrawDataAt(libraw_data_t *librawData, long visibleCol, long visibleRow);

/// LibRaw indexes colors (FC, fcol) and black patterns in coordinates relative to its visible
/// area, which starts at (left_margin, top_margin) of the raw buffer. The wrapper's cropped
/// coordinates start at (cropOriginX, cropOriginY). Converting adds cropOrigin - margin, which
/// can be negative; LibRaw's color periods are 2, 6, 8 and 16, so a negative value is moved up
/// by a multiple of 48 without changing the result
static long librawVisibleCoordinate(NSInteger cropped, NSInteger offset) {
  NSInteger v = cropped + offset;
  return (long)(v >= 0 ? v : v % 48 + 48);
}

/// Non-negative v mod period, for indexing LibRaw's black-level pattern
static unsigned positiveMod(NSInteger v, unsigned period) {
  NSInteger r = v % (NSInteger)period;
  return (unsigned)(r < 0 ? r + period : r);
}

@interface LibRawRawImage ()
@property (readonly, direct) libraw_data_t *librawData;
/// cropOrigin - margin: added to a cropped coordinate to get LibRaw's visible-area coordinate
@property (readonly, direct) NSInteger visibleOffsetX;
@property (readonly, direct) NSInteger visibleOffsetY;
@end

@implementation LibRawRawImage
@synthesize bitsPerSample;
@synthesize blackLevel;
@synthesize bytesPerPixel;
@synthesize bytesPerRow;
@synthesize cfa;
@synthesize componentBlackLevels;
@synthesize componentsPerPixel;
@synthesize cropOriginX;
@synthesize cropOriginY;
@synthesize height;
@synthesize imageData;
@synthesize metadata;
@synthesize uncroppedHeight;
@synthesize uncroppedImageData;
@synthesize uncroppedWidth;
@synthesize whitePoint;
@synthesize width;

- (instancetype _Nullable) initFromLibrawData:(libraw_data_t *)librawData
                                     exifMake:(NSString * _Nullable)exifMake
                                    exifModel:(NSString * _Nullable)exifModel
                                        error:(NSError * _Nullable __autoreleasing *)error {
  self = [super init];
  if (self) {
    int rc = libraw_unpack(librawData);
    if (rc != LIBRAW_SUCCESS) {
      RDSetError(error, RDErrorCodeUnpackFailed,
                 [NSString stringWithFormat:@"libraw_unpack failed: %s", libraw_strerror(rc)], @(rc));
      return nil;
    }
    if (strcmp(librawData->idata.cdesc, "RGBG") != 0) {
      RDSetError(error, RDErrorCodeUnsupportedCFA,
                 [NSString stringWithFormat:@"Unrecognized color filter array: %s", librawData->idata.cdesc], nil);
      return nil;
    }
    if (!librawData->idata.filters) {
      RDSetError(error, RDErrorCodeUnsupportedCFA, @"Raw file has unknown or unsupported CFA", nil);
      return nil;
    }
    // Fujifilm SuperCCD sensors are stored rotated 45 degrees; LibRaw colors them with FCF() and
    // un-rotates them only during post-processing, which this framework does not use. Their raw
    // buffer is not a rectangular CFA image (review B12). RawSpeed decodes these files
    if (librawData->rawdata.ioparams.fuji_width != 0) {
      RDSetError(error, RDErrorCodeUnsupportedCFA,
                 @"Fujifilm SuperCCD sensor layout is not supported by the LibRaw decoder", nil);
      return nil;
    }
    // The wrapper reads raw_image: one 16-bit component per pixel. LibRaw fills color3/color4
    // or float buffers instead for some files; so far every such file also has filters == 0
    // and is rejected above, but nothing guarantees the pairing
    if (librawData->rawdata.raw_image == NULL) {
      RDSetError(error, RDErrorCodeUnsupportedPixelFormat,
                 @"Unsupported pixel format: LibRaw did not produce a single-component 16-bit image", nil);
      return nil;
    }
    _librawData = librawData;
    const libraw_image_sizes_t *sizes = &librawData->sizes;

    // Uncropped is the whole raw buffer, which is what uncroppedImageData points at. LibRaw's
    // width/height are its visible area, not the buffer (review B1)
    uncroppedWidth = sizes->raw_width;
    uncroppedHeight = sizes->raw_height;
    uncroppedImageData = librawData->rawdata.raw_image;

    // Crop: the vendor inset crop when LibRaw considers it usable, using LibRaw's own rule from
    // adjust_to_raw_inset_crop: an origin of 0xFFFF means "unknown" (many Sony ARW files report
    // a size with an unknown origin), and the crop must lie inside the raw buffer (review B13).
    // Otherwise the visible area, which starts at the margins
    const libraw_raw_inset_crop_t *inset = &sizes->raw_inset_crops[0];
    BOOL insetUsable = inset->cwidth > 0 && inset->cheight > 0
        && inset->cleft < 0xffff && inset->ctop < 0xffff
        && (NSInteger)inset->cleft + inset->cwidth <= (NSInteger)sizes->raw_width
        && (NSInteger)inset->ctop + inset->cheight <= (NSInteger)sizes->raw_height;
    if (insetUsable) {
      cropOriginX = inset->cleft;
      cropOriginY = inset->ctop;
      width = inset->cwidth;
      height = inset->cheight;
    } else {
      cropOriginX = sizes->left_margin;
      cropOriginY = sizes->top_margin;
      width = MIN((NSInteger)sizes->width, (NSInteger)sizes->raw_width - cropOriginX);
      height = MIN((NSInteger)sizes->height, (NSInteger)sizes->raw_height - cropOriginY);
    }
    if (width <= 0 || height <= 0) {
      RDSetError(error, RDErrorCodeDecodeFailed, @"LibRaw reported no usable image area", nil);
      _librawData = NULL;
      return nil;
    }
    _visibleOffsetX = cropOriginX - sizes->left_margin;
    _visibleOffsetY = cropOriginY - sizes->top_margin;

    // We'll assume 2
    bytesPerPixel = 2;
    bytesPerRow = sizes->raw_pitch;
    imageData = &librawData->rawdata.raw_image[cropOriginX + cropOriginY * bytesPerRow / 2];

    // The CFA pattern starting at the crop origin, in LibRaw's visible frame (B4), sized to the
    // pattern's real period (review B3): 6x6 for X-Trans (filters == 9), 16x16 for LibRaw's
    // Leaf/Kodak table (filters == 1), and for Bayer 2 columns by 2 rows, or 8 rows when the
    // 8-row pattern encoded in filters does not repeat every 2 rows
    NSInteger cfaWidth = 2, cfaHeight = 2;
    if (librawData->idata.filters == 9) {
      cfaWidth = 6; cfaHeight = 6;
    } else if (librawData->idata.filters == 1) {
      cfaWidth = 16; cfaHeight = 16;
    } else {
      for (int row = 2; row < 8 && cfaHeight == 2; row++) {
        for (int col = 0; col < 2; col++) {
          if (libraw_COLOR(librawData, row, col) != libraw_COLOR(librawData, row % 2, col)) {
            cfaHeight = 8;
            break;
          }
        }
      }
    }
    RDCFAColor *cfaColors = (RDCFAColor *)malloc(sizeof(RDCFAColor) * (size_t)(cfaWidth * cfaHeight));
    for (NSInteger y = 0; y < cfaHeight; y++) {
      for (NSInteger x = 0; x < cfaWidth; x++) {
        cfaColors[x + y * cfaWidth] = libRawImageColorWithLibrawDataAt(librawData,
                                                                       librawVisibleCoordinate(x, _visibleOffsetX),
                                                                       librawVisibleCoordinate(y, _visibleOffsetY));
      }
    }
    cfa = [[RDCFA alloc] initWithCFAColors:cfaColors
                                     width:cfaWidth
                                    height:cfaHeight];
    free(cfaColors);

    // Black levels at the 2x2 tile at the crop origin, also in the visible frame. LibRaw's black
    // level for a pixel is black + cblack[color] + the pattern entry
    // cblack[6 + (row % cblack[4]) * cblack[5] + (col % cblack[5])] when a pattern is present.
    // Every X-Trans file in the dataset has a uniform black level, so four values suffice
    const unsigned *cblack = librawData->color.cblack;
    const unsigned patternRows = cblack[4], patternCols = cblack[5];
    NSMutableArray<NSNumber *> *levels = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger y = 0; y < 2; y++) {
      for (NSInteger x = 0; x < 2; x++) {
        long visibleCol = librawVisibleCoordinate(x, _visibleOffsetX);
        long visibleRow = librawVisibleCoordinate(y, _visibleOffsetY);
        int color = libraw_COLOR(librawData, (int)visibleRow, (int)visibleCol);
        unsigned level = librawData->color.black + (color >= 0 && color < 4 ? cblack[color] : 0);
        if (patternRows > 0 && patternCols > 0) {
          level += cblack[6 + positiveMod(y + _visibleOffsetY, patternRows) * patternCols
                            + positiveMod(x + _visibleOffsetX, patternCols)];
        }
        [levels addObject:@(level)];
      }
    }
    componentBlackLevels = levels;
    blackLevel = [[NSSet setWithArray:levels] count] == 1 ? levels[0] : nil;
    // We'll assume 1
    componentsPerPixel = 1;
    metadata = [[RDRawImageMetadata alloc] initFromLibrawData:librawData
                                                      exifMake:exifMake
                                                     exifModel:exifModel];
    // linear_max is the white level from the file's own metadata, and LibRaw sets it to 0
    // when the file has none (many RAF, SRW and SR2 files, and DNGs whose opcodes LibRaw
    // applies). It can also be present but nonsensical: LibRaw 0.22.2 reads 153 for the Canon
    // EOS R50 V, below its black level of 511. In either case fall back to maximum, LibRaw's
    // per-camera or data-derived ceiling
    NSInteger highestBlack = [[componentBlackLevels valueForKeyPath:@"@max.self"] integerValue];
    whitePoint = librawData->color.linear_max[0];
    if (whitePoint <= highestBlack) {
      whitePoint = librawData->color.maximum;
    }
    bitsPerSample = whitePoint > 0 ? (uint16_t)ceil(log2(whitePoint)) : 0;
  }
  return self;
}

- (void)dealloc {
  libraw_close(_librawData);
}

- (RDCFAColor)colorAtX:(NSInteger)x y:(NSInteger)y {
  return libRawRawImageColorAt(self, x, y);
}

- (uint16_t)valueAtRow:(NSInteger)row col:(NSInteger)col {
  return libRawRawImageValueAt(self, row, col);
}

- (uint16_t)valueAtUncroppedRow:(NSInteger)row col:(NSInteger)col {
  return libRawRawImageValueAtUncropped(self, row, col);
}

@end

RDCFAColor libRawImageColorWithLibrawDataAt(libraw_data_t *librawData, long visibleCol, long visibleRow) {
  RDCFAColor color;
  int librawColor = libraw_COLOR(librawData, (int)visibleRow, (int)visibleCol);
  switch (librawColor) {
    case 0: // R
      color = RDCFAColorRed;
      break;
    case 1: // G1
      color = RDCFAColorGreen;
      break;
    case 2: // B
      color = RDCFAColorBlue;
      break;
    case 3: // G2
      color = RDCFAColorGreen;
      break;
    default:
      NSCAssert(false, @"Unexpected libraw color: %d", librawColor);
      assert(false);
  }
  return color;
}

RDCFAColor libRawRawImageColorAt(LibRawRawImage *__unsafe_unretained rawImage, NSInteger x, NSInteger y) {
  return libRawImageColorWithLibrawDataAt(rawImage.librawData,
                                          librawVisibleCoordinate(x, rawImage.visibleOffsetX),
                                          librawVisibleCoordinate(y, rawImage.visibleOffsetY));
}

uint16_t libRawRawImageValueAt(LibRawRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col) {
  NSCAssert(row >= 0 && row < rawImage.height,
            @"row is out of bounds: %ld", row);
  NSCAssert(col >= 0 && col < rawImage.width,
            @"col is out of bounds: %ld", col);
  return libRawRawImageValueAtUncropped(rawImage,
                                        row + rawImage.cropOriginY,
                                        col + rawImage.cropOriginX);
}

uint16_t libRawRawImageValueAtUncropped(LibRawRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col) {
  NSCAssert(row >= 0 && row < rawImage.uncroppedHeight,
            @"row is out of bounds: %ld", row);
  NSCAssert(col >= 0 && col < rawImage.uncroppedWidth,
            @"col is out of bounds: %ld", col);
  return rawImage.librawData->rawdata.raw_image[col + row * rawImage.bytesPerRow / 2];
}
