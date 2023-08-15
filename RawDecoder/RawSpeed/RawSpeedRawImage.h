#import <Foundation/Foundation.h>

#import <RawDecoder/RDRawImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface RawSpeedRawImage: NSObject <RDRawImage>
+ (RawSpeedRawImage * _Nullable)fromData:(const NSData *)data
                                   error:(NSError * _Nullable *)error;

+ (RawSpeedRawImage * _Nullable)fromData:(const NSData *)data
                        correctRawValues:(bool)correctRawValues
                                   error:(NSError * _Nullable *)error;

+ (RawSpeedRawImage * _Nullable)fromFileURL:(const NSURL *)fileURL
                                      error:(NSError * _Nullable *)error;

+ (RawSpeedRawImage * _Nullable)fromFileURL:(const NSURL *)fileURL
                           correctRawValues:(bool)correctRawValues
                                      error:(NSError * _Nullable *)error;

- (instancetype)init NS_UNAVAILABLE;
@end

#if __cplusplus
extern "C" {
#endif

RDCFAColor rawSpeedRawImageColorAt(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger x, NSInteger y);

uint16_t rawSpeedRawImageValueAt(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col);

uint16_t rawSpeedRawImageValueAtUncropped(RawSpeedRawImage *__unsafe_unretained rawImage, NSInteger row, NSInteger col);

#if __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
