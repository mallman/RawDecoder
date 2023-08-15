#import "LibRawRawImage.h"

#import <RawDecoder/RDErrorDomain.h>

#import <libraw.h>

@interface RDCFA ()
- (instancetype) initWithCFAColors:(RDCFAColor *)cfaColors
                             width:(NSInteger)width
                            height:(NSInteger)height;
@end

@interface RDRawImageMetadata ()
- (instancetype)initFromLibrawData:(libraw_data_t *)librawData;
@end

RDCFAColor libRawImageColorWithLibrawDataAt(libraw_data_t *librawData, long x, long y);

@interface LibRawRawImage ()
@property (readonly, direct) libraw_data_t *librawData;
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

+ (void) setErrorWithMessage:(NSString *)errorMessage
                       error:(NSError * _Nullable __autoreleasing *)error {
  int errCode = -1;
  NSDictionary *errorDictionary = @{
    NSLocalizedDescriptionKey: errorMessage
  };
  *error = [NSError errorWithDomain:RDErrorDomain
                               code:errCode
                           userInfo:errorDictionary];
}

+ (LibRawRawImage * _Nullable)fromData:(const NSData *)data
                                 error:(NSError * _Nullable __autoreleasing *)error {
  libraw_data_t *librawData = libraw_init(0);
  int rc = libraw_open_buffer(librawData, (const uint8_t *)data.bytes, (uint32_t)data.length);
  if (rc != LIBRAW_SUCCESS) {
    [self setErrorWithMessage:[NSString stringWithFormat:@"libraw_open_buffer failed with error code: %d", rc]
                        error:error];
    return nil;
  }
  LibRawRawImage *rawImage = [[LibRawRawImage alloc] initFromLibrawData:librawData
                                                                  error:error];
  if (rawImage == nil) {
    libraw_close(librawData);
  }
  return rawImage;
}

+ (LibRawRawImage * _Nullable) fromFileURL:(const NSURL *)fileURL
                                     error:(NSError * _Nullable __autoreleasing *)error {
  libraw_data_t *librawData = libraw_init(0);
  const char *rawFilePath = [[fileURL path] UTF8String];
  int rc = libraw_open_file(librawData, rawFilePath);
  if (rc != LIBRAW_SUCCESS) {
    [self setErrorWithMessage:[NSString stringWithFormat:@"libraw_open_file failed with error code: %d", rc]
                        error:error];
    return nil;
  }
  LibRawRawImage *rawImage = [[LibRawRawImage alloc] initFromLibrawData:librawData
                                                                  error:error];
  if (rawImage == nil) {
    libraw_close(librawData);
  }
  return rawImage;
}

- (instancetype _Nullable) initFromLibrawData:(libraw_data_t *)librawData
                                        error:(NSError * _Nullable __autoreleasing *)error {
  self = [super init];
  if (self) {
    int rc = libraw_unpack(librawData);
    if (rc != LIBRAW_SUCCESS) {
      [LibRawRawImage setErrorWithMessage:[NSString stringWithFormat:@"libraw_unpack failed with error code: %d", rc]
                                    error:error];
      return nil;
    }
    if (strcmp(librawData->idata.cdesc, "RGBG") != 0) {
      [LibRawRawImage setErrorWithMessage:[NSString stringWithFormat:@"Unrecognized color filter array: %s",
                                           librawData->idata.cdesc]
                                    error:error];
      return nil;
    }
    if (!librawData->idata.filters) {
      [LibRawRawImage setErrorWithMessage:[NSString stringWithFormat:@"Raw file has unknown or unsupported CFA"]
                                    error:error];
      return nil;
    }
    _librawData = librawData;
    blackLevel = librawData->color.black;
    // We'll assume 2
    bytesPerPixel = 2;
    bytesPerRow = librawData->sizes.raw_pitch;
    RDCFAColor *cfaColors = (RDCFAColor *)malloc(sizeof(RDCFAColor) * 4);
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 2; x++) {
        cfaColors[x + y * 2] = libRawImageColorWithLibrawDataAt(librawData, x, y);
      }
    }
    cfa = [[RDCFA alloc] initWithCFAColors:cfaColors
                                     width:2
                                    height:2];
    free(cfaColors);
    // We'll assume we have four component black levels, and they're all the same as the main black level
    componentBlackLevels = @[[NSNumber numberWithLong:blackLevel],
                             [NSNumber numberWithLong:blackLevel],
                             [NSNumber numberWithLong:blackLevel],
                             [NSNumber numberWithLong:blackLevel]];
    // We'll assume 1
    componentsPerPixel = 1;
    uncroppedHeight = librawData->sizes.height;
    uncroppedWidth = librawData->sizes.width;
    if (librawData->sizes.raw_inset_crops[0].cheight == 0) {
      cropOriginX = 0;
      cropOriginY = 0;
      height = uncroppedHeight;
      width = uncroppedWidth;
    } else {
      cropOriginX = librawData->sizes.raw_inset_crops[0].cleft;
      cropOriginY = librawData->sizes.raw_inset_crops[0].ctop;
      height = librawData->sizes.raw_inset_crops[0].cheight;
      width = librawData->sizes.raw_inset_crops[0].cwidth;
    }
    imageData = &librawData->rawdata.raw_image[cropOriginX + cropOriginY * bytesPerRow / 2];
    uncroppedImageData = librawData->rawdata.raw_image;
    metadata = [[RDRawImageMetadata alloc] initFromLibrawData:librawData];
    whitePoint = librawData->color.linear_max[0];
    bitsPerSample = (uint16_t)ceil(log2(whitePoint));
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

RDCFAColor libRawImageColorWithLibrawDataAt(libraw_data_t *librawData, long x, long y) {
  RDCFAColor color;
  int librawColor = libraw_COLOR(librawData, (int)y, (int)x);
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
  return libRawImageColorWithLibrawDataAt(rawImage.librawData, x, y);
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
