#import <RawSpeed-API.h>

#import <libraw.h>

#import "RDRawImageMetadata.h"

@implementation RDRawImageMetadata
- (instancetype)initFromImageMetadata:(rawspeed::ImageMetaData)metadata {
  self = [super init];
  if (self) {
    _cameraMake = [NSString stringWithUTF8String:metadata.make.data()];
    _cameraModel = [NSString stringWithUTF8String:metadata.model.data()];
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
    _whiteBalanceCoefficients = @[
      [NSNumber numberWithFloat: metadata.wbCoeffs[0]],
      [NSNumber numberWithFloat: metadata.wbCoeffs[1]],
      [NSNumber numberWithFloat: metadata.wbCoeffs[2]],
      [NSNumber numberWithFloat: metadata.wbCoeffs[3]]
    ];
  }
  return self;
}

- (instancetype)initFromLibrawData:(libraw_data_t *)librawData {
  self = [super init];
  if (self) {
    _cameraMake = [NSString stringWithUTF8String:librawData->idata.make];
    _cameraModel = [NSString stringWithUTF8String:librawData->idata.model];
    _cameraMode = nil; // I don't think we'll get this out of LibRaw
    _canonicalCameraMake = [NSString stringWithUTF8String:librawData->idata.normalized_make];
    _canonicalCameraModel = [NSString stringWithUTF8String:librawData->idata.normalized_model];
    _canonicalCameraId = [NSString stringWithFormat:@"%@ %@", _canonicalCameraMake, _canonicalCameraModel];
    _canonicalCameraAlias = [NSString stringWithUTF8String:librawData->idata.normalized_model];
    _iso = (NSInteger)floor(librawData->other.iso_speed);
    _pixelAspectRatio = librawData->sizes.pixel_aspect;
    // Not sure where to get this. Not sure I care either...
//    _whiteBalanceCoefficients =
  }
  return self;
}
@end
