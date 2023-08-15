#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// A smattering of raw image metadata, inspired mainly by RawSpeed
@interface RDRawImageMetadata: NSObject
@property (readonly) NSString *cameraMake;
@property (readonly) NSString *cameraModel;

/// The raw file recording format, like 14-bit compressed, etc.
@property (readonly,nullable) NSString *cameraMode;
@property (readonly) NSString *canonicalCameraMake;
@property (readonly) NSString *canonicalCameraModel;
@property (readonly) NSString *canonicalCameraId;
@property (readonly) NSString *canonicalCameraAlias;
@property (readonly) NSInteger iso;
@property (readonly) double pixelAspectRatio;
@property (readonly) NSArray<NSNumber*> *whiteBalanceCoefficients;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
