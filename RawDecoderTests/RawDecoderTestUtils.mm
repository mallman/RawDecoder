#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@interface RDRawSpeedDecoder ()
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                  correctRawValues:(bool)correctRawValues
                                             error:(NSError * _Nullable __autoreleasing *)error;

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                     correctRawValues:(bool)correctRawValues
                                                error:(NSError * _Nullable __autoreleasing *)error;
@end

@implementation RawDecoderTestUtils

+ (NSString *) rawPixlsDataPath {
  NSString *envVar = @"RAW_PIXLS_DATA_DIR";
  NSString *rawPixlsDataDirectory = [[[NSProcessInfo processInfo] environment] objectForKey:envVar];
  XCTAssertNotNil(rawPixlsDataDirectory, @"No value for environment variable %@", envVar);
  return rawPixlsDataDirectory;
}

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath
                               withDecoder:(id<RDRawImageDecoder>)decoder {
  NSString *rawFilePath = [NSString stringWithFormat:@"%@/%@", [RawDecoderTestUtils rawPixlsDataPath], pixlsFilePath];
  NSURL *rawFileUrl = [NSURL fileURLWithPath:rawFilePath
                                 isDirectory:false];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                                withDecoder:decoder];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                           withDecoder:(id<RDRawImageDecoder>)decoder {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  NSURL *rawFileUrl = [testBundle URLForResource:resource withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                                withDecoder:decoder];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(bool)correctRawValues {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  NSURL *rawFileUrl = [testBundle URLForResource:resource withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                           correctRawValues:correctRawValues];
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withDecoder:(id<RDRawImageDecoder>)decoder {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;

  NSData *rawData = [NSData dataWithContentsOfURL:rawFileUrl];
  id<RDRawImage>rawImageFromData = [decoder decodeRawImageFromData:rawData
                                                             error:&error];
  XCTAssertNotNil(rawImageFromData, @"Failed to load raw image from data at %@: %@", [rawFileUrl path], error);

  id<RDRawImage>rawImage = [decoder decodeRawImageFromFileURL:rawFileUrl
                                                        error:&error];
  //  if (rawImage == nil) {
  //    printf("@\"%s\",\n", [[[rawFileUrl path] substringFromIndex:45] UTF8String]);
  //  }
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                correctRawValues:(bool)correctRawValues {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;

  NSData *rawData = [NSData dataWithContentsOfURL:rawFileUrl];
  id<RDRawImage>rawImageFromData = [RDRawSpeedDecoder decodeRawImageFromData:rawData
                                                            correctRawValues:correctRawValues
                                                                       error:&error];
  XCTAssertNotNil(rawImageFromData, @"Failed to load raw image from data at %@: %@", [rawFileUrl path], error);

  id<RDRawImage>rawImage = [RDRawSpeedDecoder decodeRawImageFromFileURL:rawFileUrl
                                                       correctRawValues:correctRawValues
                                                                  error:&error];
  //  if (rawImage == nil) {
  //    printf("@\"%s\",\n", [[[rawFileUrl path] substringFromIndex:45] UTF8String]);
  //  }
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

@end
