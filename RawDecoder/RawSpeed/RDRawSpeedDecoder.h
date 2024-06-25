#import <Foundation/Foundation.h>
#import <RawDecoder/RDRawImageDecoder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDRawSpeedDecoder: NSObject <RDRawImageDecoder>
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                  correctRawValues:(bool)correctRawValues
                                             error:(NSError * _Nullable *)error;

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                     correctRawValues:(bool)correctRawValues
                                                error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
