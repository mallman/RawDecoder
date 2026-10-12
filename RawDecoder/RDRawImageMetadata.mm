#import <RawSpeed-API.h>

#import <libraw.h>

#import "RDRawImageMetadata.h"

@implementation RDRawImageMetadata
- (instancetype)initFromImageMetadata:(rawspeed::ImageMetaData)metadata {
  self = [super init];
  if (self) {
    _cameraMake = metadata.make.empty() ? nil : [NSString stringWithUTF8String:metadata.make.data()];
    _cameraModel = metadata.model.empty() ? nil : [NSString stringWithUTF8String:metadata.model.data()];
    NSString *cameraMode = [NSString stringWithUTF8String:metadata.mode.data()];
    if ([cameraMode length] == 0) {
      _cameraMode = nil;
    } else {
      _cameraMode = cameraMode;
    }
    _canonicalCameraMake = [NSString stringWithUTF8String:metadata.canonical_make.data()];
    _canonicalCameraModel = [NSString stringWithUTF8String:metadata.canonical_model.data()];
    _canonicalCameraId = [NSString stringWithUTF8String:metadata.canonical_id.data()];
    _canonicalCameraAlias = [NSString stringWithUTF8String:metadata.canonical_alias.data()];
    _iso = metadata.isoSpeed;
    _pixelAspectRatio = metadata.pixelAspectRatio;
    // RawSpeed reports white balance as an Optional; absent means the file had none
    if (metadata.wbCoeffs) {
      const std::array<float, 4> &wbCoeffs = *metadata.wbCoeffs;
      _whiteBalanceCoefficients = @[
        [NSNumber numberWithFloat: wbCoeffs[0]],
        [NSNumber numberWithFloat: wbCoeffs[1]],
        [NSNumber numberWithFloat: wbCoeffs[2]],
        [NSNumber numberWithFloat: wbCoeffs[3]]
      ];
    } else {
      _whiteBalanceCoefficients = nil;
    }
  }
  return self;
}

- (instancetype)initFromLibrawData:(libraw_data_t *)librawData
                          exifMake:(NSString * _Nullable)exifMake
                         exifModel:(NSString * _Nullable)exifModel {
  self = [super init];
  if (self) {
    // LibRaw rewrites idata.make/model; the originals come from the EXIF capture, and are
    // nil for containers without a TIFF structure (CIFF-based CRW, MDC)
    _cameraMake = exifMake;
    _cameraModel = exifModel;
    _cameraMode = nil; // I don't think we'll get this out of LibRaw
    _canonicalCameraMake = [NSString stringWithUTF8String:librawData->idata.normalized_make];
    _canonicalCameraModel = [NSString stringWithUTF8String:librawData->idata.normalized_model];
    _canonicalCameraId = [NSString stringWithFormat:@"%@ %@", _canonicalCameraMake, _canonicalCameraModel];
    _canonicalCameraAlias = [NSString stringWithUTF8String:librawData->idata.normalized_model];
    _iso = (NSInteger)floor(librawData->other.iso_speed);
    _pixelAspectRatio = librawData->sizes.pixel_aspect;
    // LibRaw's own post-processing treats cam_mul[0] <= 0.00001 as "no as-shot white
    // balance parsed from the file" (postprocessing_utils_dcrdefs.cpp); use the same rule
    _whiteBalanceCoefficients = librawData->color.cam_mul[0] <= 0.00001f ? nil : @[
      [NSNumber numberWithFloat: librawData->color.cam_mul[0]],
      [NSNumber numberWithFloat: librawData->color.cam_mul[1]],
      [NSNumber numberWithFloat: librawData->color.cam_mul[2]],
      [NSNumber numberWithFloat: librawData->color.cam_mul[3]]
    ];
  }
  return self;
}
@end
