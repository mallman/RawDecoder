#import "RDRawSpeedDecoder.h"
#import "RawSpeedRawImage.h"

#import "cameraMetaData.h"
#import "../RDError+Private.h"

#import <RawSpeed-API.h>

@implementation RDRawSpeedDecoder
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(nonnull NSData *)data
                                             error:(NSError * _Nullable __autoreleasing *)error {
  return [self decodeRawImageFromData:data
                     correctRawValues:YES
                                error:error];
}

+ (id<RDRawImage> _Nullable) decodeRawImageFromData:(NSData *)data
                                   correctRawValues:(BOOL)correctRawValues
                                              error:(NSError * _Nullable __autoreleasing *)error {
  try {
    auto buffer = new rawspeed::Buffer((const uint8_t *)data.bytes, (uint32_t) data.length);
    RawSpeedRawImage *rawImage = [self fromBuffer:buffer
                                 correctRawValues:correctRawValues
                                            error:error];
    return rawImage;
  } catch (std::exception& ex) {
    RDSetError(error, RDErrorCodeDecodeFailed, [NSString stringWithUTF8String:ex.what()], nil);
    return nil;
  }
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(nonnull NSURL *)fileURL
                                                error:(NSError * _Nullable __autoreleasing *)error {
  return [self decodeRawImageFromFileURL:fileURL
                        correctRawValues:YES
                                   error:error];
}

+ (id<RDRawImage> _Nullable) decodeRawImageFromFileURL:(NSURL *)fileURL
                                      correctRawValues:(BOOL)correctRawValues
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
    RDSetError(error, RDErrorCodeDecodeFailed, [NSString stringWithUTF8String:ex.what()], nil);
    return nil;
  }
}

+ (RawSpeedRawImage * _Nullable) fromBuffer:(const rawspeed::Buffer *)buffer
                           correctRawValues:(BOOL)correctRawValues
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
