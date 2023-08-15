#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@interface RawPixlsTests: XCTestCase
@end

@implementation RawPixlsTests

static NSSet<NSString *> *knownFailingFiles = [NSSet setWithArray: @[
  @"Apple/iPhone 12 Pro/IMG_1361.DNG",

  @"Canon/Canon PowerShot S100V/Canon_PS-S100V_FW1.0.2.0.CR2",
  @"Canon/EOS 40D/_MG_0154.CR2",
  @"Canon/EOS 50D/IMG_9517.CR2",
  @"Canon/EOS 50D/IMG_9518.CR2",
  @"Canon/EOS 5D Mark II/09.canon.sraw1.cr2",
  @"Canon/EOS 5D Mark II/10.canon.sraw2.cr2",
  @"Canon/EOS 5D Mark III/5G4A9395.CR2",
  @"Canon/EOS 5D Mark III/5G4A9396.CR2",
  @"Canon/EOS 5D Mark IV/B13A0732.CR2",
  @"Canon/EOS 5D Mark IV/B13A0733.CR2",
  @"Canon/EOS 5DS R/_DSR2003.CR2",
  @"Canon/EOS 5DS R/_DSR2004.CR2",
  @"Canon/EOS 5DS/2K4A9928.CR2",
  @"Canon/EOS 5DS/2K4A9929.CR2",
  @"Canon/EOS 60D/IMG_2015.CR2",
  @"Canon/EOS 60D/IMG_2016.CR2",
  @"Canon/EOS 6D Mark II/6DII-mRAW.CR2",
  @"Canon/EOS 6D Mark II/6DII-sRAW.CR2",
  @"Canon/EOS 6D/EOS_6D_mRAW.CR2",
  @"Canon/EOS 6D/EOS_6D_sRAW.CR2",
  @"Canon/EOS 70D/mRAW_CANON_EOS70D_01.CR2",
  @"Canon/EOS 70D/sRAW_CANON_EOS70D_01.CR2",
  @"Canon/EOS 7D/RAW_CANON_EOS_7D-mraw.CR2",
  @"Canon/EOS 7D/RAW_CANON_EOS_7D-sraw.CR2",
  @"Canon/EOS 7D Mark II/capture000107.cr2",
  @"Canon/EOS 7D Mark II/capture000108.cr2",
  @"Canon/EOS 80D/IMG_0096.CR2",
  @"Canon/EOS 80D/IMG_0097.CR2",
  @"Canon/EOS-1D Mark IV/IMG_5395.CR2",
  @"Canon/EOS-1D Mark IV/IMG_5398.CR2",
  @"Canon/EOS-1D X Mark II/AZ1I2271.CR2",
  @"Canon/EOS-1D X Mark II/AZ1I2272.CR2",

  @"Fujifilm/DBP for GX680/DSCF0010.RAF",

  @"Leica/LEICA M MONOCHROM (Typ 246)/M2462362.DNG",
  @"Leica/M Monochrom/L1000622.DNG",

  @"Nikon/Coolpix E8800/DSCN6207.NEF",
  @"Nikon/D4S/FU9_3802.NEF",
  @"Nikon/D810/DSC_1888.NEF",
  @"Nikon/E8400/DSCN1565.NEF",
  @"Nikon/NIKON Z 8/Nikon_Z8_high_efficiency_low.NEF",
  @"Nikon/NIKON Z 8/Nikon_Z8_raw_high_efficiency_hight.NEF",
  @"Nikon/NIKON Z 9/Nikon_-_NIKON_Z_9_-_14bit_compressed_(Lossy_High_Efficiency).NEF",
  @"Nikon/NIKON Z 9/Nikon_-_NIKON_Z_9_-_14bit_compressed_(Lossy_High_Efficiency_Star).NEF",
  @"Nikon/Nikon COOLSCAN IV ED/NEF_from_Nikon_Scan_4.0.3_at_600dpi.nef",
  @"Nikon/Nikon COOLSCAN V ED/Image21-600pixels.nef",

  @"Samsung/Galaxy S23 Ultra/20230228_163710.dng",
  @"Samsung/SM-G973U/20200402_181931.dng",
  @"Samsung/SM-S908U/20221120_114119.dng",

  @"Sony/ILCE-7RM5/7RM5-LosslessCompressedMedium.ARW",
  @"Sony/ILCE-7RM5/7RM5-LosslessCompressedSmall.ARW",
  @"Sony/ILCE-7RM5/7RM5-S35-LosslessCompressedSmall.ARW",
]];

- (void)test3FRDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"3FR"];
}

- (void)testARWDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ARW"];
}

- (void)testAppleDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Apple"];
}

- (void)testCR2Decoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR2"];
}

- (void)testCR3Decoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR3"
                                      withLibrary:RDLibRaw];
}

- (void)testDJIDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"DJI"];
}

- (void)testFFFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"FFF"];
}

- (void)testGPRDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"GPR"];
}

- (void)testGoogleDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Google"];
}

- (void)testHasselbladDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"HASSELBLAD"];
}

- (void)testIIQDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"IIQ"];
}

- (void)testLeicaDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Leica"];
}

- (void)testLeicaRAWDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
                                      inDirectory:@"Leica"];
}

- (void)testMDCDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"MDC"];
}

- (void)testMRWDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"MRW"];
}

- (void)testNEFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"NEF"];
}

- (void)testORFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORF"];
}

- (void)testORIDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORI"];
}

- (void)testPEFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"PEF"];
}

- (void)testPentaxDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Pentax"];
}

- (void)testPentaxRAWDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
                                      inDirectory:@"Pentax"];
}

- (void)testRAFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAF"];
}

- (void)testRW2Decoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RW2"];
}

- (void)testRWLDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RWL"];
}

- (void)testSR2Decoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SR2"];
}

- (void)testSRFDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRF"];
}

- (void)testSRWDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRW"];
}

- (void)testSamsungDNGDecoding {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Samsung"];
}

- (void)testCanonR8 {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Canon/Canon EOS R8/CRAW_FULL_FRAME.CR3"];
  if (rawImage == nil) {
    return;
  }

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 168);
  XCTAssertEqual(rawImage.cropOriginY, 108);
  XCTAssertEqual(rawImage.width, 6000);
  XCTAssertEqual(rawImage.height, 4000);
  XCTAssertEqual(rawImage.uncroppedWidth, 5999);
  XCTAssertEqual(rawImage.uncroppedHeight, 3999);

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

  XCTAssertEqual(rawImage.whitePoint, 14008);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 200);
  XCTAssertEqualObjects(metadata.cameraMake, @"Canon");
  XCTAssertEqualObjects(metadata.cameraModel, @"EOS R8");
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Canon");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"EOS R8");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Canon EOS R8");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"EOS R8");
}

- (void)testNikonD850 {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Nikon/D850/Nikon-D850-14bit-lossless-compressed.NEF"
                             withLibrary:RDRawSpeed];
  if (rawImage == nil) {
    return;
  }

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

- (void)testSonyDSCR1 {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Sony/DSC-R1/_DSC1477.SR2"
                             withLibrary:RDRawSpeed];
  if (rawImage == nil) {
    return;
  }

  XCTAssertEqual(rawImage.bitsPerSample, 14);
  XCTAssertEqual(rawImage.bytesPerPixel, 2);
  XCTAssertEqual(rawImage.componentsPerPixel, 1);

  XCTAssertEqual(rawImage.cropOriginX, 0);
  XCTAssertEqual(rawImage.cropOriginY, 0);
  XCTAssertEqual(rawImage.width, 3924);
  XCTAssertEqual(rawImage.height, 2608);
  XCTAssertEqual(rawImage.uncroppedWidth, 3984);
  XCTAssertEqual(rawImage.uncroppedHeight, 2608);

  XCTAssertEqual([rawImage colorAtX:0 y:0], RDCFAColorGreen);
  XCTAssertEqual([rawImage colorAtX:1 y:0], RDCFAColorRed);
  XCTAssertEqual([rawImage colorAtX:0 y:1], RDCFAColorBlue);
  XCTAssertEqual([rawImage colorAtX:1 y:1], RDCFAColorGreen);

  NSArray<NSNumber*> *expectedExifCFAPattern = @[
    [NSNumber numberWithInt:1],
    [NSNumber numberWithInt:0],
    [NSNumber numberWithInt:2],
    [NSNumber numberWithInt:1]
  ];
  XCTAssertEqualObjects(expectedExifCFAPattern, rawImage.cfa.exifCFAPattern);

  XCTAssertEqual(rawImage.blackLevel, 511);
  NSArray<NSNumber*> *expectedComponentBlackLevels = @[
    [NSNumber numberWithInt:511],
    [NSNumber numberWithInt:511],
    [NSNumber numberWithInt:511],
    [NSNumber numberWithInt:511]
  ];
  XCTAssertEqualObjects(expectedComponentBlackLevels, rawImage.componentBlackLevels);

  XCTAssertEqual(rawImage.whitePoint, 16383);

  RDRawImageMetadata *metadata = rawImage.metadata;
  XCTAssertEqual(metadata.pixelAspectRatio, 1);
  XCTAssertEqual(metadata.iso, 160);
  XCTAssertEqualObjects(metadata.cameraMake, @"SONY");
  XCTAssertEqualObjects(metadata.cameraModel, @"DSC-R1");
  XCTAssertNil(metadata.cameraMode);
  XCTAssertEqualObjects(metadata.canonicalCameraMake, @"Sony");
  XCTAssertEqualObjects(metadata.canonicalCameraModel, @"DSC-R1");
  XCTAssertEqualObjects(metadata.canonicalCameraId, @"Sony DSC-R1");
  XCTAssertEqualObjects(metadata.canonicalCameraAlias, @"DSC-R1");
}

+ (void)testDecodingOfFilesWithExtension:(NSString *)fileExtension {
  [self testDecodingOfFilesWithExtension:fileExtension
                             inDirectory:@""];
}

+ (void)testDecodingOfFilesWithExtension:(NSString *)fileExtension
                             inDirectory:(NSString *)directory {
  if ([directory length] == 0) {
    NSLog(@"Testing decoding of files with extension %@", fileExtension);
  } else {
    if (![directory hasSuffix:@"/"]) {
      directory = [directory stringByAppendingString:@"/"];
    }
    NSLog(@"Testing decoding of files with extension %@ in %@", fileExtension, directory);
  }

  NSFileManager *fm = [NSFileManager defaultManager];
  NSError *error;
  NSString *rootPath = [NSString stringWithFormat:@"%@/%@", [RawDecoderTestUtils rawPixlsDataPath], directory];
  NSArray<NSString *> *rawPixlsPaths = [[fm subpathsOfDirectoryAtPath:rootPath
                                                                error:&error]
                                        sortedArrayUsingSelector:@selector(compare:)];
  XCTAssertNotNil(rawPixlsPaths, @"Failed to list raw pixls paths: %@", error);

  NSMutableArray<NSString *> *rawPixlsFormatPaths = [NSMutableArray new];
  for (NSUInteger i = 0; i < rawPixlsPaths.count; i++) {
    NSString *path = rawPixlsPaths[i];
    NSString *rawFilePath = [directory stringByAppendingString:path];
    if ([[rawFilePath lowercaseString] hasSuffix:[NSString stringWithFormat:@".%@", [fileExtension lowercaseString]]]) {
      if ([knownFailingFiles containsObject:rawFilePath]) {
        continue;
      }
      [rawPixlsFormatPaths addObject:rawFilePath];
    }
  }

  NSLog(@"Found %lu files with extension %@", (unsigned long)rawPixlsFormatPaths.count, fileExtension);

  for (NSUInteger i = 0; i < rawPixlsFormatPaths.count; i++) {
    if (i > 0 && i % 10 == 0) {
      NSLog(@"Progress: %lu%%", i * 100 / rawPixlsFormatPaths.count);
    }
    NSString *path = rawPixlsFormatPaths[i];
    [RawDecoderTestUtils rawImageAtPixlsFilePath:path];
  }
}

+ (void)testDecodingOfFilesWithExtension:(NSString *)fileExtension
                             withLibrary:(RDRawImageDecoderLibrary)library {
  NSLog(@"Testing decoding of files with extension %@", fileExtension);

  NSFileManager *fm = [NSFileManager defaultManager];
  NSError *error;
  NSArray<NSString *> *rawPixlsPaths = [[fm subpathsOfDirectoryAtPath:[RawDecoderTestUtils rawPixlsDataPath]
                                                                error:&error] sortedArrayUsingSelector:@selector(compare:)];
  XCTAssertNotNil(rawPixlsPaths, @"Failed to list raw pixls paths: %@", error);

  NSMutableArray<NSString *> *rawPixlsFormatPaths = [NSMutableArray new];
  for (NSUInteger i = 0; i < rawPixlsPaths.count; i++) {
    NSString *path = rawPixlsPaths[i];
    if ([[path lowercaseString] hasSuffix:[NSString stringWithFormat:@".%@", [fileExtension lowercaseString]]]) {
      if ([knownFailingFiles containsObject:path]) {
        continue;
      }
      [rawPixlsFormatPaths addObject:path];
    }
  }

  NSLog(@"Found %lu files with extension %@", (unsigned long)rawPixlsFormatPaths.count, fileExtension);

  for (NSUInteger i = 0; i < rawPixlsFormatPaths.count; i++) {
    if (i > 0 && i % 10 == 0) {
      NSLog(@"Progress: %lu%%", i * 100 / rawPixlsFormatPaths.count);
    }
    NSString *path = rawPixlsFormatPaths[i];
    [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                     withLibrary:library];
  }
}

@end
