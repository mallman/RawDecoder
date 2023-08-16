#import <Foundation/Foundation.h>

#import <RawDecoder/RDRawImage.h>

#import <RawSpeed-API.h>

NS_ASSUME_NONNULL_BEGIN

@interface RawSpeedRawImage: NSObject <RDRawImage>
- (instancetype)init NS_UNAVAILABLE;

- (instancetype _Nullable) initWithRawImage:(rawspeed::RawImage)rawImage
                                      error:(NSError * _Nullable __autoreleasing *)error;
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
