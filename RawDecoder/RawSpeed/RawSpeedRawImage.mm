#import "RawSpeedRawImage.h"

#import <RawSpeed-API.h>

#import "cameraMetaData.h"
#import <RawDecoder/RDErrorDomain.h>

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

+ (RawSpeedRawImage * _Nullable) fromData:(const NSData *)data
                                    error:(NSError * _Nullable __autoreleasing *)error {
  return [self fromData:data
       correctRawValues:true
                  error:error];
}

+ (RawSpeedRawImage * _Nullable) fromData:(const NSData *)data
                         correctRawValues:(bool)correctRawValues
                                    error:(NSError * _Nullable __autoreleasing *)error {
  try {
    auto buffer = new rawspeed::Buffer((const uint8_t *)data.bytes, (uint32_t) data.length);
    RawSpeedRawImage *rawImage = [self fromBuffer:buffer
                                 correctRawValues:correctRawValues
                                            error:error];
    return rawImage;
  } catch (std::exception& ex) {
    [self setErrorWithMessage:[NSString stringWithUTF8String: ex.what()] error:error];
    return nil;
  }
}

+ (RawSpeedRawImage * _Nullable) fromFileURL:(const NSURL *)fileURL
                                       error:(NSError * _Nullable __autoreleasing *)error {
  return [self fromFileURL:fileURL
          correctRawValues:true
                     error:error];
}

+ (RawSpeedRawImage * _Nullable) fromFileURL:(const NSURL *)fileURL
                            correctRawValues:(bool)correctRawValues
                                       error:(NSError * _Nullable __autoreleasing *)error {
  try {
    const char *filename = [[fileURL path] UTF8String];
    rawspeed::FileReader fileReader(filename);
    auto [storage, storageBuf] = fileReader.readFile();
    RawSpeedRawImage *rawImage = [self fromBuffer:&storageBuf
                                 correctRawValues:correctRawValues
                                            error:error];
    storage.reset();
    return rawImage;
  } catch (std::exception& ex) {
    [self setErrorWithMessage:[NSString stringWithUTF8String: ex.what()] error:error];
    return nil;
  }
}

+ (RawSpeedRawImage * _Nullable) fromBuffer:(const rawspeed::Buffer *)buffer
                            correctRawValues:(bool)correctRawValues
                                       error:(NSError * _Nullable __autoreleasing *)error {
  rawspeed::RawParser parser(*buffer);
  const rawspeed::CameraMetaData *meta = cameraMetaData();
  auto decoder = parser.getDecoder(meta);
  decoder->failOnUnknown = true;
  decoder->uncorrectedRawValues = !correctRawValues;
  decoder->checkSupport(meta);
  decoder->decodeRaw();
  decoder->decodeMetaData(meta);
  rawspeed::RawImage rawSpeedRawImage = decoder->mRaw;
  const auto errors = rawSpeedRawImage->getErrors();
  for(const auto &decodingError : errors) {
    printf("Raw decoding error: %s\n", decodingError.c_str());
  }
  RawSpeedRawImage *rawImage = [[RawSpeedRawImage alloc] initWithRawImage:rawSpeedRawImage
                                                                    error:error];
  decoder.reset();
  return rawImage;
}

- (instancetype _Nullable) initWithRawImage:(rawspeed::RawImage)rawImage
                                      error:(NSError * _Nullable __autoreleasing *)error {
  self = [super init];
  if (self) {
    try {
      _rawImage = new rawspeed::RawImage(rawImage);
      rawspeed::RawImageData *rawImageData = _rawImage->get();
      rawspeed::CroppedArray2DRef<uint16_t> croppedImageArray = rawImageData->getU16DataAsCroppedArray2DRef();
      imageData = &croppedImageArray(0, 0);
      rawspeed::Array2DRef<uint16_t> uncroppedImageArray = rawImageData->getU16DataAsUncroppedArray2DRef();
      uncroppedImageData = &uncroppedImageArray(0, 0);
      bytesPerPixel = rawImageData->getBpp();
      bytesPerRow = rawImageData->pitch;
      if (!rawImage->isCFA) {
        [RawSpeedRawImage setErrorWithMessage:@"Raw image has no color filter array" error:error];
        return nil;
      }
      _colorFilterArray = rawImageData->cfa;
      cfa = [[RDCFA alloc] initWithCFA:_colorFilterArray];
      componentsPerPixel = rawImage->getCpp();
      cropOriginX = croppedImageArray.offsetCols;
      cropOriginY = croppedImageArray.offsetRows;
      bitsPerSample = (uint16_t)ceil(log2(rawImage->whitePoint));
      blackLevel = rawImageData->blackLevel;
      if (rawImageData->blackLevelSeparate[0] == -1
          || rawImageData->blackLevelSeparate[1] == -1
          || rawImageData->blackLevelSeparate[2] == -1
          || rawImageData->blackLevelSeparate[3] == -1) {
        rawImageData->calculateBlackAreas();
      }
      NSMutableArray<NSNumber*> *componentBlackLevels0 = [NSMutableArray new];
      for (auto blackLevel0 : rawImageData->blackLevelSeparate) {
        [componentBlackLevels0 addObject:[NSNumber numberWithInt:blackLevel0]];
      }
      componentBlackLevels = componentBlackLevels0;
      height = croppedImageArray.croppedHeight;
      width = croppedImageArray.croppedWidth;
      uncroppedHeight = uncroppedImageArray.height;
      uncroppedWidth = uncroppedImageArray.width;
      metadata = [[RDRawImageMetadata alloc] initFromImageMetadata:rawImageData->metadata];
      whitePoint = rawImageData->whitePoint;
    } catch (std::exception& ex) {
      [RawSpeedRawImage setErrorWithMessage:[NSString stringWithUTF8String: ex.what()] error:error];
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