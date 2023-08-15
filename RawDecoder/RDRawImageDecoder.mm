#import <exception>

#import "RDRawImageDecoder.h"

#import "LibRawRawImage.h"
#import "RawSpeedRawImage.h"

@implementation RDRawImageDecoder
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                             error:(NSError * _Nullable __autoreleasing *)error {
  id<RDRawImage> rawImage = [RDRawImageDecoder decodeRawImageFromData:data
                                                          withLibrary:RDRawSpeed
                                                                error:error];

  if (*error != nil) {
    *error = nil;
    NSLog(@"Received error trying to decode with RawSpeed. Falling back to LibRaw");
    rawImage = [RDRawImageDecoder decodeRawImageFromData:data
                                             withLibrary:RDLibRaw
                                                   error:error];
  }

  return rawImage;
}

/// A module-private method for decoding a raw image with RawSpeed, passing the `correctRawValues`
/// parameter. This is mainly used for testing, to compare decoded values between the decoder
/// backends
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                  correctRawValues:(bool)correctRawValues
                                             error:(NSError * _Nullable __autoreleasing *)error {
  return [RawSpeedRawImage fromData:data
                   correctRawValues:correctRawValues
                              error:error];
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                       withLibrary:(RDRawImageDecoderLibrary)library
                                             error:(NSError * _Nullable __autoreleasing *)error {
  switch (library) {
    case RDLibRaw:
      return [LibRawRawImage fromData:data
                                error:error];
      break;
    case RDRawSpeed:
      return [RawSpeedRawImage fromData:data
                                  error:error];
      break;
  }
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                                error:(NSError * _Nullable __autoreleasing *)error {
  id<RDRawImage> rawImage = [RDRawImageDecoder decodeRawImageFromFileURL:fileURL
                                                             withLibrary:RDRawSpeed
                                                                   error:error];

  if (*error != nil) {
    *error = nil;
    NSLog(@"Received error trying to decode with RawSpeed. Falling back to LibRaw");
    rawImage = [RDRawImageDecoder decodeRawImageFromFileURL:fileURL
                                                withLibrary:RDLibRaw
                                                      error:error];
  }

  return rawImage;
}

/// A module-private method for decoding a raw image with RawSpeed, passing the `correctRawValues`
/// parameter. This is mainly used for testing, to compare decoded values between the decoder
/// backends
+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                     correctRawValues:(bool)correctRawValues
                                                error:(NSError * _Nullable __autoreleasing *)error {
  return [RawSpeedRawImage fromFileURL:fileURL
                      correctRawValues:correctRawValues
                                 error:error];
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                          withLibrary:(RDRawImageDecoderLibrary)library
                                                error:(NSError * _Nullable __autoreleasing *)error {
  switch (library) {
    case RDLibRaw:
      return [LibRawRawImage fromFileURL:fileURL
                                   error:error];
      break;
    case RDRawSpeed:
      return [RawSpeedRawImage fromFileURL:fileURL
                                     error:error];
      break;
  }
}
@end
