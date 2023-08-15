#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@interface RDRawImageDecoder ()
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

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath {
  NSString *rawFilePath = [NSString stringWithFormat:@"%@/%@", [RawDecoderTestUtils rawPixlsDataPath], pixlsFilePath];
  NSURL *rawFileUrl = [NSURL fileURLWithPath:rawFilePath
                                 isDirectory:false];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl];
}

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath
                               withLibrary:(RDRawImageDecoderLibrary)library {
  NSString *rawFilePath = [NSString stringWithFormat:@"%@/%@", [RawDecoderTestUtils rawPixlsDataPath], pixlsFilePath];
  NSURL *rawFileUrl = [NSURL fileURLWithPath:rawFilePath
                                 isDirectory:false];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                                withLibrary:library];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension {
  return [RawDecoderTestUtils rawImageForResource:resource
                                    withExtension:extension
                                      withLibrary:RDRawSpeed];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                           withLibrary:(RDRawImageDecoderLibrary)library {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  NSURL *rawFileUrl = [testBundle URLForResource:resource withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                                withLibrary:library];
}

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(bool)correctRawValues {
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  NSURL *rawFileUrl = [testBundle URLForResource:resource withExtension:extension];
  return [RawDecoderTestUtils rawImageAtURL:rawFileUrl
                           correctRawValues:correctRawValues];
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;

  NSData *rawData = [NSData dataWithContentsOfURL:rawFileUrl];
  id<RDRawImage>rawImageFromData = [RDRawImageDecoder decodeRawImageFromData:rawData
                                                                       error:&error];
  XCTAssertNotNil(rawImageFromData, @"Failed to load raw image from data at %@: %@", [rawFileUrl path], error);

  id<RDRawImage>rawImage = [RDRawImageDecoder decodeRawImageFromFileURL:rawFileUrl
                                                                  error:&error];
  //  if (rawImage == nil) {
  //    printf("@\"%s\",\n", [[[rawFileUrl path] substringFromIndex:45] UTF8String]);
  //  }
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withLibrary:(RDRawImageDecoderLibrary)library {
  XCTAssertNotNil(rawFileUrl, @"Couldn't find file at %@", [rawFileUrl path]);
  NSError *error;

  NSData *rawData = [NSData dataWithContentsOfURL:rawFileUrl];
  id<RDRawImage>rawImageFromData = [RDRawImageDecoder decodeRawImageFromData:rawData
                                                                 withLibrary:library
                                                                       error:&error];
  XCTAssertNotNil(rawImageFromData, @"Failed to load raw image from data at %@: %@", [rawFileUrl path], error);

  id<RDRawImage>rawImage = [RDRawImageDecoder decodeRawImageFromFileURL:rawFileUrl
                                                            withLibrary:library
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
  id<RDRawImage>rawImageFromData = [RDRawImageDecoder decodeRawImageFromData:rawData
                                                            correctRawValues:correctRawValues
                                                                       error:&error];
  XCTAssertNotNil(rawImageFromData, @"Failed to load raw image from data at %@: %@", [rawFileUrl path], error);

  id<RDRawImage>rawImage = [RDRawImageDecoder decodeRawImageFromFileURL:rawFileUrl
                                                       correctRawValues:correctRawValues
                                                                  error:&error];
  //  if (rawImage == nil) {
  //    printf("@\"%s\",\n", [[[rawFileUrl path] substringFromIndex:45] UTF8String]);
  //  }
  XCTAssertNotNil(rawImage, @"Failed to load raw image at %@: %@", [rawFileUrl path], error);
  return rawImage;
}

@end
