#import "RawSpeedRawImage.h"

#import "cameraMetaData.h"
#import "../RDError+Private.h"

@interface RDCFA ()
- (instancetype) initWithCFA:(rawspeed::ColorFilterArray)cfa;
@end

@interface RDRawImageMetadata ()
- (instancetype)initFromImageMetadata:(rawspeed::ImageMetaData)metadata;
@end

@interface RawSpeedRawImage ()
@property (readonly, direct) rawspeed::ColorFilterArray colorFilterArray;
@property (readonly, direct) rawspeed::RawImage *rawImage;
@end

@implementation RawSpeedRawImage
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

- (instancetype _Nullable) initWithRawImage:(rawspeed::RawImage)rawImage
                                      error:(NSError * _Nullable __autoreleasing *)error {
  self = [super init];
  if (self) {
    try {
      _rawImage = new rawspeed::RawImage(rawImage);
      rawspeed::RawImageData *rawImageData = _rawImage->get();
      // Check the format before touching the pixel data: the accessors below assume 16-bit
      // samples, and RawSpeed decodes some files (floating-point DNGs) to 32-bit floats
      if (!rawImage->isCFA) {
        RDSetError(error, RDErrorCodeNoCFA, @"Raw image has no color filter array", nil);
        return nil;
      }
      if (rawImageData->getDataType() != rawspeed::RawImageType::UINT16 ||
          rawImageData->getCpp() != 1 || rawImageData->getBpp() != 2) {
        RDSetError(error, RDErrorCodeUnsupportedPixelFormat,
                   [NSString stringWithFormat:@"Unsupported pixel format: %s, %u component(s), %u bytes per pixel",
                    rawImageData->getDataType() == rawspeed::RawImageType::F32 ? "32-bit float" : "16-bit integer",
                    rawImageData->getCpp(), rawImageData->getBpp()], nil);
        return nil;
      }
      rawspeed::CroppedArray2DRef<uint16_t> croppedImageArray = rawImageData->getU16DataAsCroppedArray2DRef();
      imageData = &croppedImageArray(0, 0);
      rawspeed::Array2DRef<uint16_t> uncroppedImageArray = rawImageData->getU16DataAsUncroppedArray2DRef();
      uncroppedImageData = &uncroppedImageArray(0, 0);
      bytesPerPixel = rawImageData->getBpp();
      bytesPerRow = rawImageData->pitch;
      componentsPerPixel = rawImage->getCpp();
      cropOriginX = croppedImageArray.offsetCols;
      cropOriginY = croppedImageArray.offsetRows;
      // RawSpeed shifts the CFA to the crop origin when it crops (RawImageData::subFrame), except
      // for X-Trans (dcraw filter 9) and the 16x16 Leaf pattern (filter 1), which it leaves
      // relative to the uncropped sensor; its consumers apply the crop offset themselves. Do the
      // same shift here so cfa and colorAtX:y: are relative to the crop origin like imageData
      _colorFilterArray = rawImageData->cfa;
      uint32_t dcrawFilter = _colorFilterArray.getDcrawFilter();
      if (dcrawFilter == 1 || dcrawFilter == 9) {
        _colorFilterArray.shiftRight((int)cropOriginX);
        _colorFilterArray.shiftDown((int)cropOriginY);
      }
      cfa = [[RDCFA alloc] initWithCFA:_colorFilterArray];
      bitsPerSample = (uint16_t)ceil(log2(*rawImage->whitePoint));
      if (!rawImageData->blackLevelSeparate) {
        rawImageData->calculateBlackAreas();
      }
      // RawSpeed indexes blackLevelSeparate by parity in uncropped sensor coordinates
      // (2 * (y & 1) + (x & 1)); its own scaling re-indexes by the crop offset. Do the same so
      // componentBlackLevels is in the cropped frame, like cfa and imageData. RawSpeed's scalar
      // blackLevel is -1 whenever the levels are per-channel, so it is not used
      auto blackLevelSeparate = *(*rawImageData->blackLevelSeparate).getAsArray1DRef();
      NSMutableArray<NSNumber *> *levels = [NSMutableArray arrayWithCapacity:4];
      for (NSInteger y = 0; y < 2; y++) {
        for (NSInteger x = 0; x < 2; x++) {
          int index = (int)(2 * ((y + cropOriginY) & 1) + ((x + cropOriginX) & 1));
          [levels addObject:@(blackLevelSeparate(index))];
        }
      }
      componentBlackLevels = levels;
      blackLevel = [[NSSet setWithArray:levels] count] == 1 ? levels[0] : nil;
      height = croppedImageArray.croppedHeight;
      width = croppedImageArray.croppedWidth;
      uncroppedHeight = uncroppedImageArray.height();
      uncroppedWidth = uncroppedImageArray.width();
      metadata = [[RDRawImageMetadata alloc] initFromImageMetadata:rawImageData->metadata];
      whitePoint = *rawImageData->whitePoint;
    } catch (std::exception& ex) {
      RDSetError(error, RDErrorCodeDecodeFailed, [NSString stringWithUTF8String:ex.what()], nil);
      return nil;
    }
  }
  return self;
}

- (void) dealloc {
  delete _rawImage;
}

- (RDCFAColor) colorAtX:(NSInteger)x
                      y:(NSInteger)y {
  return rawSpeedRawImageColorAt(self, x, y);
}

- (uint16_t) valueAtRow:(NSInteger)row
                    col:(NSInteger)col {
  return rawSpeedRawImageValueAt(self, row, col);
}

- (uint16_t) valueAtUncroppedRow:(NSInteger)row
                             col:(NSInteger)col {
  return rawSpeedRawImageValueAtUncropped(self, row, col);
}
@end

#if __cplusplus
extern "C" {
#endif

RDCFAColor rawSpeedRawImageColorAt(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger x, NSInteger y) {
  rawspeed::ColorFilterArray colorFilterArray = rawImage.colorFilterArray;
  rawspeed::CFAColor cfaColor = colorFilterArray.getColorAt((int)x, (int)y);
  return RDCFAColor(cfaColor);
}

uint16_t rawSpeedRawImageValueAt(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col) {
  return rawImage.rawImage->get()->getU16DataAsCroppedArray2DRef()((int)row, (int)col);
}

uint16_t rawSpeedRawImageValueAtUncropped(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col) {
  return rawImage.rawImage->get()->getU16DataAsUncroppedArray2DRef()((int)row, (int)col);
}

#if __cplusplus
}
#endif
