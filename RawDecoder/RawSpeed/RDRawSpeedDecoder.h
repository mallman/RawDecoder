#import <Foundation/Foundation.h>
#import <RawDecoder/RDRawImageDecoder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDRawSpeedDecoder: NSObject <RDRawImageDecoder>
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(NSData *)data
                                  correctRawValues:(BOOL)correctRawValues
                                             error:(NSError * _Nullable *)error;

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(NSURL *)fileURL
                                     correctRawValues:(BOOL)correctRawValues
                                                error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
