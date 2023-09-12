#ifndef RawDecoderTestUtils_h
#define RawDecoderTestUtils_h

NS_ASSUME_NONNULL_BEGIN

@interface RawDecoderTestUtils: NSObject

+ (NSURL *) urlForResource:(NSString *)resource
             withExtension:(NSString *)extension;

+ (NSString *) rawPixlsDataPath;

+ (id<RDRawImage>) rawImageAtPixlsFilePath:(NSString *)pixlsFilePath
                               withDecoder:(id<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                           withDecoder:(id<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageForResource:(NSString *)resource
                         withExtension:(NSString *)extension
                      correctRawValues:(bool)correctRawValues;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                     withDecoder:(id<RDRawImageDecoder>)decoder;

+ (id<RDRawImage>) rawImageAtURL:(NSURL *)rawFileUrl
                correctRawValues:(bool)correctRawValues;
@end

NS_ASSUME_NONNULL_END

#endif /* RawDecoderTestUtils_h */
