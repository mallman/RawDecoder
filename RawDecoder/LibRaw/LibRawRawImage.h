#import <Foundation/Foundation.h>

#import <RawDecoder/RDRawImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibRawRawImage: NSObject <RDRawImage>
+ (LibRawRawImage * _Nullable)fromData:(const NSData *)data
                                 error:(NSError * _Nullable *)error;

+ (LibRawRawImage * _Nullable)fromFileURL:(const NSURL *)fileURL
                                    error:(NSError * _Nullable *)error;

- (instancetype)init NS_UNAVAILABLE;
@end

#if __cplusplus
extern "C" {
#endif

RDCFAColor libRawRawImageColorAt(LibRawRawImage *__unsafe_unretained rawImage, NSInteger x, NSInteger y);

uint16_t libRawRawImageValueAt(LibRawRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col);

uint16_t libRawRawImageValueAtUncropped(LibRawRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col);

#if __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
