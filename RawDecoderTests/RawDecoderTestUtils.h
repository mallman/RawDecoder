#ifndef RawDecoderTestUtils_h
#define RawDecoderTestUtils_h

NS_ASSUME_NONNULL_BEGIN

@interface RawDecoderTestUtils: NSObject

+ (NSString *) rawPixlsDataPath;

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath;

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath
                               withLibrary:(RDRawImageDecoderLibrary)library;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                           withLibrary:(RDRawImageDecoderLibrary)library;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(bool)correctRawValues;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withLibrary:(RDRawImageDecoderLibrary)library;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                correctRawValues:(bool)correctRawValues;
@end

NS_ASSUME_NONNULL_END

#endif /* RawDecoderTestUtils_h */
