#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@implementation RawDecoderTestUtils

+ (NSURL *) urlForResource:(NSString *)resource
             withExtension:(NSString *)extension {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  return [testBundle URLForResource:resource withExtension:extension];
}

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
  NSURL *rawFileUrl = [RawDecoderTestUtils urlForResource:resource
                                            withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                                withDecoder:decoder];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(bool)correctRawValues {
  NSURL *rawFileUrl = [RawDecoderTestUtils urlForResource:resource
                                            withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                           correctRawValues:correctRawValues];
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withDecoder:(id<RDRawImageDecoder>)decoder {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;
  id<RDRawImage>rawImage = [decoder decodeRawImageFromFileURL:rawFileUrl
                                                        error:&error];
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                correctRawValues:(bool)correctRawValues {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;
  id<RDRawImage>rawImage = [RDRawSpeedDecoder decodeRawImageFromFileURL:rawFileUrl
                                                       correctRawValues:correctRawValues
                                                                  error:&error];
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

@end
