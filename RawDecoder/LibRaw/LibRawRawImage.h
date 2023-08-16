#import <Foundation/Foundation.h>
#import <RawDecoder/RDRawImage.h>
#import <libraw.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibRawRawImage: NSObject <RDRawImage>
- (instancetype)init NS_UNAVAILABLE;

- (instancetype _Nullable) initFromLibrawData:(libraw_data_t *)librawData
                                        error:(NSError * _Nullable __autoreleasing *)error;
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
