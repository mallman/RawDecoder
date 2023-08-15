#import <Foundation/Foundation.h>

#import <RawDecoder/RDRawImage.h>
#import <RawDecoder/RDRawImageDecoderLibrary.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// A raw image decoder. This decodes raw image data or a raw image file to an `RDRawImage`
@interface RDRawImageDecoder: NSObject
- (instancetype)init NS_UNAVAILABLE;

/// Decodes raw image data. This method attempts to decode with RawSpeed first, falling back to
/// LibRaw if it encounters a problem. If it fails to decode with LibRaw, it will return an error
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                             error:(NSError * _Nullable *)error;

/// Decodes raw image data. This method will attempt to decode `data` using `library` only,
/// returning an error if it fails
+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(const NSData *)data
                                       withLibrary:(RDRawImageDecoderLibrary)library
                                             error:(NSError * _Nullable *)error;

/// Decodes a raw image file. This method attempts to decode with RawSpeed first, falling back to
/// LibRaw if it encounters a problem. If it fails to decode with LibRaw, it will return an error
+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                                error:(NSError * _Nullable *)error;

/// Decodes a raw image file. This method will attempt to decode `fileURL` using `library` only,
/// returning an error if it fails
+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(const NSURL *)fileURL
                                          withLibrary:(RDRawImageDecoderLibrary)library
                                                error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
