#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// A smattering of raw image metadata, inspired mainly by RawSpeed
@interface RDRawImageMetadata: NSObject

/// The camera make exactly as written in the file's EXIF/TIFF `Make` tag, e.g.
/// "NIKON CORPORATION". nil when the container carries no such tag (CIFF-based CRW files).
/// Both decoders return the same value for the same file. For a stable camera identity use
/// `canonicalCameraMake` and `canonicalCameraModel`, which are never nil
@property (readonly, nullable) NSString *cameraMake;

/// The camera model exactly as written in the file's EXIF/TIFF `Model` tag, e.g.
/// "NIKON D850". nil when the container carries no such tag. See `cameraMake`
@property (readonly, nullable) NSString *cameraModel;

/// The raw file recording format, like 14-bit compressed, etc.
@property (readonly,nullable) NSString *cameraMode;
@property (readonly) NSString *canonicalCameraMake;
@property (readonly) NSString *canonicalCameraModel;
@property (readonly) NSString *canonicalCameraId;
@property (readonly) NSString *canonicalCameraAlias;
@property (readonly) NSInteger iso;
@property (readonly) double pixelAspectRatio;
/// The as-shot white balance multipliers, four values in CFA color order. nil when the
/// decoder found no as-shot white balance in the file. Each decoder decides this for itself,
/// so for the same file one decoder can return nil while the other returns values.
/// Values are as the file stores them and are not normalized: they may be scaled so green
/// is 1, or be the camera's integer multipliers. Compare ratios to green, not raw values.
/// The fourth value is 0 or a second green depending on decoder and file
@property (readonly, nullable) NSArray<NSNumber*> *whiteBalanceCoefficients;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
