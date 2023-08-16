#import <Foundation/Foundation.h>

#import <RawDecoder/RDRawImage.h>

NS_ASSUME_NONNULL_BEGIN

/// A raw image decoder. This decodes raw image data or a raw image file to an `RDRawImage`
@protocol RDRawImageDecoder
/// Decodes raw image data
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                             error:(NSError * _Nullable *)error;

/// Decodes a raw image file
+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                                error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
