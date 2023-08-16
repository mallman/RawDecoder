#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@interface RawDecoderTests: XCTestCase
@end

@implementation RawDecoderTests

- (void) testD200RawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D200 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 12);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 2);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 3898);
  XCTAssertEqual(rawImage.height, 2616);
  XCTAssertEqual(rawImage.uncroppedWidth, 3904);
  XCTAssertEqual(rawImage.uncroppedHeight, 2616);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:1], // G
    [NSNumber numberWithInt:0], // R
    [NSNumber numberWithInt:2], // B
    [NSNumber numberWithInt:1]  // G
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorBlue);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorGreen);

  XCTAssertEqual(rawImage.blackLevel, 0);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 3880);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 100);
  XCTAssertEqualObjects(metadata.cameraMake, @"NIKON CORPORATION");
  XCTAssertEqualObjects(metadata.cameraModel, @"NIKON D200");
  XCTAssertEqualObjects(metadata.cameraMode, @"12bit-uncompressed");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D200");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D200");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D200");
}

- (void) testD200LibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D200 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 12);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 0);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 3899);
  XCTAssertEqual(rawImage.height, 2616);
  XCTAssertEqual(rawImage.uncroppedWidth, 3899);
  XCTAssertEqual(rawImage.uncroppedHeight, 2616);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:1], // G
    [NSNumber numberWithInt:0], // R
    [NSNumber numberWithInt:2], // B
    [NSNumber numberWithInt:1]  // G
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorBlue);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorGreen);

  XCTAssertEqual(rawImage.blackLevel, 0);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 3827);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 100);
  XCTAssertEqualObjects(metadata.cameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.cameraModel, @"D200");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D200");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D200");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D200");
}

- (void) testD800ERawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D800E Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 2);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 7374);
  XCTAssertEqual(rawImage.height, 4924);
  XCTAssertEqual(rawImage.uncroppedWidth, 7424);
  XCTAssertEqual(rawImage.uncroppedHeight, 4924);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  XCTAssertEqual(rawImage.blackLevel, 0);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15520);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 100);
  XCTAssertEqualObjects(metadata.cameraMake, @"NIKON CORPORATION");
  XCTAssertEqualObjects(metadata.cameraModel, @"NIKON D800E");
  XCTAssertEqualObjects(metadata.cameraMode, @"14bit-compressed");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D800E");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D800E");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D800E");
}

- (void) testD800ELibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D800E Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 0);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 7378);
  XCTAssertEqual(rawImage.height, 4924);
  XCTAssertEqual(rawImage.uncroppedWidth, 7378);
  XCTAssertEqual(rawImage.uncroppedHeight, 4924);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  XCTAssertEqual(rawImage.blackLevel, 0);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:0]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15311);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 100);
  XCTAssertEqualObjects(metadata.cameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.cameraModel, @"D800E");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D800E");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D800E");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D800E");
}

- (void) testD810RawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D810 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 0);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 7380);
  XCTAssertEqual(rawImage.height, 4928);
  XCTAssertEqual(rawImage.uncroppedWidth, 7380);
  XCTAssertEqual(rawImage.uncroppedHeight, 4928);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  XCTAssertEqual(rawImage.blackLevel, 600);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15520);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 400);
  XCTAssertEqualObjects(metadata.cameraMake, @"NIKON CORPORATION");
  XCTAssertEqualObjects(metadata.cameraModel, @"NIKON D810");
  XCTAssertEqualObjects(metadata.cameraMode, @"14bit-compressed");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D810");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D810");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D810");
}

- (void) testD810LibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D810 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 0);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 7380);
  XCTAssertEqual(rawImage.height, 4928);
  XCTAssertEqual(rawImage.uncroppedWidth, 7380);
  XCTAssertEqual(rawImage.uncroppedHeight, 4928);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  XCTAssertEqual(rawImage.blackLevel, 600);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600],
    [NSNumber numberWithInt:600]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15311);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 400);
  XCTAssertEqualObjects(metadata.cameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.cameraModel, @"D810");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D810");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D810");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D810");
}

- (void) testD850RawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D850 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 16);
  XCTAssertEqual(rawImage.cropOriginY, 8);
  XCTAssertEqual(rawImage.width, 8256);
  XCTAssertEqual(rawImage.height, 5504);
  XCTAssertEqual(rawImage.uncroppedWidth, 8288);
  XCTAssertEqual(rawImage.uncroppedHeight, 5520);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual(rawImage.blackLevel, 400);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15520);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 64);
  XCTAssertEqualObjects(metadata.cameraMake, @"NIKON CORPORATION");
  XCTAssertEqualObjects(metadata.cameraModel, @"NIKON D850");
  XCTAssertEqualObjects(metadata.cameraMode, @"14bit-compressed");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D850");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D850");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D850");
}

- (void) testD850LibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Nikon D850 Raw Image 1"
                                                       withExtension:@"NEF"
                                                         withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 16);
  XCTAssertEqual(rawImage.cropOriginY, 8);
  XCTAssertEqual(rawImage.width, 8256);
  XCTAssertEqual(rawImage.height, 5504);
  XCTAssertEqual(rawImage.uncroppedWidth, 8288);
  XCTAssertEqual(rawImage.uncroppedHeight, 5520);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual(rawImage.blackLevel, 400);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400],
    [NSNumber numberWithInt:400]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15311);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 64);
  XCTAssertEqualObjects(metadata.cameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.cameraModel, @"D850");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Nikon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"D850");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Nikon D850");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"D850");
}

- (void) testD850RawSpeedValues {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageForResource:@"Nikon D850 Raw Image 1"
                             withExtension:@"NEF"
                             correctRawValues:false]; // The "uncorrected" RawSpeed values match the LibRaw values
  [RawDecoderTests testD850RawImageValuesWithRawImage:rawImage];
}

- (void) testD850LibRawValues {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageForResource:@"Nikon D850 Raw Image 1"
                             withExtension:@"NEF"
                             withDecoder:[RDLibRawDecoder self]];
  [RawDecoderTests testD850RawImageValuesWithRawImage:rawImage];
}

+ (void) testD850RawImageValuesWithRawImage:(id<RDRawImage>)rawImage {
  assertImageValuesEqual(rawImage, 0, 0, 799);
  assertImageValuesEqual(rawImage, 0, 1, 1609);
  assertImageValuesEqual(rawImage, 0, 2, 790);
  assertImageValuesEqual(rawImage, 0, 3, 1570);
  assertImageValuesEqual(rawImage, 1, 0, 1595);
  assertImageValuesEqual(rawImage, 1, 1, 1773);
  assertImageValuesEqual(rawImage, 1, 2, 1626);
  assertImageValuesEqual(rawImage, 1, 3, 1815);
  assertImageValuesEqual(rawImage, 2, 0, 786);
  assertImageValuesEqual(rawImage, 2, 2, 787);

  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX, 803);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX, 1619);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX + 1, 1616);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX + 1, 1809);

  assertImageValuesEqual(rawImage, 5517, 8285, 608);
  assertImageValuesEqual(rawImage, 5517, 8287, 648);
  assertImageValuesEqual(rawImage, 5518, 8284, 947);
  assertImageValuesEqual(rawImage, 5518, 8285, 1086);
  assertImageValuesEqual(rawImage, 5518, 8286, 927);
  assertImageValuesEqual(rawImage, 5518, 8287, 1106);
  assertImageValuesEqual(rawImage, 5519, 8284, 1070);
  assertImageValuesEqual(rawImage, 5519, 8285, 602);
  assertImageValuesEqual(rawImage, 5519, 8286, 1167);
  assertImageValuesEqual(rawImage, 5519, 8287, 670);
}

- (void) testD850RawSpeedVersusLibRaw {
  [self checkRawSpeedVersusLibRawForResource:@"Nikon D850 Raw Image 1"
                               withExtension:@"NEF"
                            correctRawValues:false
                                   tolerance:0];
}

- (void) testILCE1RawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Sony ILCE-1 Raw Image 1"
                                                       withExtension:@"ARW"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 12);
  XCTAssertEqual(rawImage.cropOriginY, 12);
  XCTAssertEqual(rawImage.width, 8640);
  XCTAssertEqual(rawImage.height, 5760);
  XCTAssertEqual(rawImage.uncroppedWidth, 8672);
  XCTAssertEqual(rawImage.uncroppedHeight, 5784);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual(rawImage.blackLevel, 512);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15360);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 640);
  XCTAssertEqualObjects(metadata.cameraMake, @"SONY");
  XCTAssertEqualObjects(metadata.cameraModel, @"ILCE-1");
  XCTAssertNil(metadata.cameraMode);
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Sony");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"ILCE-1");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Sony ILCE-1");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"ILCE-1");
}

- (void) testILCE1LibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Sony ILCE-1 Raw Image 1"
                                                       withExtension:@"ARW"
                                                         withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 12);
  XCTAssertEqual(rawImage.cropOriginY, 12);
  XCTAssertEqual(rawImage.width, 8640);
  XCTAssertEqual(rawImage.height, 5760);
  XCTAssertEqual(rawImage.uncroppedWidth, 8660);
  XCTAssertEqual(rawImage.uncroppedHeight, 5784);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorBlue);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:2]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual(rawImage.blackLevel, 512);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512],
    [NSNumber numberWithInt:512]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 15360);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 640);
  XCTAssertEqualObjects(metadata.cameraMake, @"Sony");
  XCTAssertEqualObjects(metadata.cameraModel, @"ILCE-1");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Sony");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"ILCE-1");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Sony ILCE-1");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"ILCE-1");
}

- (void) testILCE1RawSpeedValues {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Sony ILCE-1 Raw Image 1"
                                                       withExtension:@"ARW"
                                                         withDecoder:[RDRawSpeedDecoder self]];

  assertImageValuesEqual(rawImage, 0, 0, 1123);
  assertImageValuesEqual(rawImage, 0, 1, 1887);
  assertImageValuesEqual(rawImage, 0, 2, 1139);
  assertImageValuesEqual(rawImage, 0, 3, 1887);
  assertImageValuesEqual(rawImage, 1, 0, 1809);
  assertImageValuesEqual(rawImage, 1, 1, 1089);
  assertImageValuesEqual(rawImage, 1, 2, 1757);
  assertImageValuesEqual(rawImage, 1, 3, 1001);
  assertImageValuesEqual(rawImage, 2, 0, 1171);
  assertImageValuesEqual(rawImage, 2, 2, 1109);

  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX, 1102);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX, 1853);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX + 1, 1871);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX + 1, 1033);
}

- (void) testILCE1LibRawValues {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageForResource:@"Sony ILCE-1 Raw Image 1"
                                                       withExtension:@"ARW"
                                                         withDecoder:[RDLibRawDecoder self]];

  assertImageValuesEqual(rawImage, 0, 0, 1124);
  assertImageValuesEqual(rawImage, 0, 1, 1888);
  assertImageValuesEqual(rawImage, 0, 2, 1140);
  assertImageValuesEqual(rawImage, 0, 3, 1888);
  assertImageValuesEqual(rawImage, 1, 0, 1810);
  assertImageValuesEqual(rawImage, 1, 1, 1090);
  assertImageValuesEqual(rawImage, 1, 2, 1758);
  assertImageValuesEqual(rawImage, 1, 3, 1002);
  assertImageValuesEqual(rawImage, 2, 0, 1172);
  assertImageValuesEqual(rawImage, 2, 2, 1110);

  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX, 1102);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX, 1854);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY, rawImage.cropOriginX + 1, 1872);
  assertImageValuesEqual(rawImage, rawImage.cropOriginY + 1, rawImage.cropOriginX + 1, 1034);
}

- (void) testILCE1RawSpeedVersusLibRaw {
  [self checkRawSpeedVersusLibRawForResource:@"Sony ILCE-1 Raw Image 1"
                               withExtension:@"ARW"
                            correctRawValues:true
                                   tolerance:2];
}

- (void) checkRawSpeedVersusLibRawForResource:(NSString *)resource
                                withExtension:(NSString *)extension
                             correctRawValues:(bool)correctRawValues
                                    tolerance:(int)tolerance {
  id<RDRawImage> rdRawImage = [RawDecoderTestUtils rawImageForResource:resource
                                                         withExtension:extension
                                                      correctRawValues:correctRawValues];
  id<RDRawImage> libRawImage = [RawDecoderTestUtils rawImageForResource:resource
                                                          withExtension:extension
                                                            withDecoder:[RDLibRawDecoder self]];

  XCTAssertEqual(rdRawImage.bitsPerSample, libRawImage.bitsPerSample);
  XCTAssertEqual(rdRawImage.blackLevel, libRawImage.blackLevel);
  XCTAssertEqual(rdRawImage.bytesPerRow, libRawImage.bytesPerRow);
  XCTAssertEqual(rdRawImage.cropOriginX, libRawImage.cropOriginX);
  XCTAssertEqual(rdRawImage.cropOriginY, libRawImage.cropOriginY);
  XCTAssertEqual(rdRawImage.height, libRawImage.height);
  XCTAssertEqual(rdRawImage.width, libRawImage.width);

  assertImageValuesEqual(rdRawImage, libRawImage, 0, 0, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, 1, 0, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, 0, 1, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, 1, 1, tolerance);

  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.cropOriginY, rdRawImage.cropOriginX, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.cropOriginY + 1, rdRawImage.cropOriginX, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.cropOriginY, rdRawImage.cropOriginX + 1, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.cropOriginY + 1, rdRawImage.cropOriginX + 1, tolerance);

  assertImageValuesEqual(rdRawImage, libRawImage, 100, 100, tolerance);

  for (int row = 100; row < 150; row++) {
    for (int col = 400; col < 450; col++) {
      assertImageValuesEqual(rdRawImage, libRawImage, row, col, tolerance);
    }
  }

  for (int row = 1000; row < 1050; row++) {
    for (int col = 2000; col < 2050; col++) {
      assertImageValuesEqual(rdRawImage, libRawImage, row, col, tolerance);
    }
  }

  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.height - 1, rdRawImage.width - 1, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.height - 2, rdRawImage.width - 1, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.height - 1, rdRawImage.width - 2, tolerance);
  assertImageValuesEqual(rdRawImage, libRawImage, rdRawImage.height - 2, rdRawImage.width - 2, tolerance);
}

void assertImageValuesEqual(id<RDRawImage> rawImage, id<RDRawImage> libRawImage, long uncroppedRow, long uncroppedCol, int tolerance);

void assertImageValuesEqual(id<RDRawImage> rawImage, id<RDRawImage> libRawImage, long uncroppedRow, long uncroppedCol, int tolerance) {
  long row = uncroppedRow - rawImage.cropOriginY;
  long col = uncroppedCol - rawImage.cropOriginX;
  if (row >= 0 && col >= 0 && row < rawImage.height && col < rawImage.width) {
    XCTAssertEqualWithAccuracy([rawImage valueAtRow:row col:col], [libRawImage valueAtRow:row col:col], tolerance);
  }
  if (uncroppedRow >= 0 && uncroppedCol >= 0 && uncroppedRow < rawImage.uncroppedHeight && uncroppedCol < rawImage.uncroppedWidth) {
    XCTAssertEqualWithAccuracy([rawImage valueAtRow:uncroppedRow col:uncroppedCol], [libRawImage valueAtRow:uncroppedRow col:uncroppedCol], tolerance);
  }
}

void assertImageValuesEqual(id<RDRawImage> rawImage, long uncroppedRow, long uncroppedCol, long value);

void assertImageValuesEqual(id<RDRawImage> rawImage, long uncroppedRow, long uncroppedCol, long value) {
  long row = uncroppedRow - rawImage.cropOriginY;
  long col = uncroppedCol - rawImage.cropOriginX;
  if (row >= 0 && col >= 0 && row < rawImage.height && col < rawImage.width) {
    XCTAssertEqual([rawImage valueAtRow:row col:col], value);
  }
  if (uncroppedRow >= 0 && uncroppedCol >= 0 && uncroppedRow < rawImage.uncroppedHeight && uncroppedCol < rawImage.uncroppedWidth) {
    XCTAssertEqual([rawImage valueAtUncroppedRow:uncroppedRow col:uncroppedCol], value);
  }
}

@end
