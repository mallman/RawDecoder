#ifndef RawDecoderTestUtils_h
#define RawDecoderTestUtils_h

NS_ASSUME_NONNULL_BEGIN

@interface RawDecoderTestUtils: NSObject

+ (NSURL *) urlForResource:(NSString *)resource
             withExtension:(NSString *)extension;

+ (NSString *) rawPixlsDataPath;

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath
                               withDecoder:(Class<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                           withDecoder:(Class<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(BOOL)correctRawValues;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withDecoder:(Class<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                correctRawValues:(BOOL)correctRawValues;
@end

NS_ASSUME_NONNULL_END

#endif /* RawDecoderTestUtils_h */
