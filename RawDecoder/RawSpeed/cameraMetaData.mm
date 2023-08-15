#import <Foundation/Foundation.h>
#import <RawSpeed-API.h>

#import "cameraMetaData.h"

const rawspeed::CameraMetaData *cameraMetaData() {
  NSBundle *rawDecoderBundle = [NSBundle bundleWithIdentifier:@"ms.allman.RawDecoder"];
  NSURL *cameraMetaDataFileUrl = [rawDecoderBundle URLForResource:@"cameras" withExtension:@"xml"];
  static rawspeed::CameraMetaData *metaData = new rawspeed::CameraMetaData([[cameraMetaDataFileUrl path] UTF8String]);
  return metaData;
}
