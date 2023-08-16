#import "RDRawSpeedDecoder.h"
#import "RawSpeedRawImage.h"

#import "cameraMetaData.h"
#import "../RDErrorDomain.h"

#import <RawSpeed-API.h>

@implementation RDRawSpeedDecoder
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

+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(nonnull const NSData *)data
                                             error:(NSError * _Nullable __autoreleasing *)error {
  return [self decodeRawImageFromData:data
                     correctRawValues:true
                                error:error];
}

+ (id<RDRawImage> _Nullable) decodeRawImageFromData:(const NSData *)data
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

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(nonnull const NSURL *)fileURL
                                                error:(NSError * _Nullable __autoreleasing *)error {
  return [self decodeRawImageFromFileURL:fileURL
                        correctRawValues:true
                                   error:error];
}

+ (id<RDRawImage> _Nullable) decodeRawImageFromFileURL:(const NSURL *)fileURL
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
@end
