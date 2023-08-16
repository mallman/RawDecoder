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

static NSSet<NSString *> *knownFailingLibRawFiles = [NSSet setWithArray: @[
  @"Nikon/E5700/20080115-DSCN1758.NEF",

  @"Panasonic/DMC-FZ38/Panasonic_DMC-FZ38_-3_2.RW2",

  @"Sony/DSC-F828/DSC06227.SRF",
]];

static NSSet<NSString *> *knownFailingRawSpeedFiles = [NSSet setWithArray: @[
  @"Canon/PowerShot SX40 HS/CRW_6036.CR2",
  @"Canon/SX150IS/CRW_1762.CR2",

  @"Fujifilm/FinePix HS33EXR/DSCF6464.RAF",
  @"Fujifilm/FinePix SL1000/RAW_file_from_Fijifilm_Finepix_SL1000.RAF",
  @"Fujifilm/GFX100S/Fujifilm-GFX100S-14bits-compress-4_3.RAF",
  @"Fujifilm/GFX100S/Fujifilm-GFX100S-16bits-compress-4_3.RAF",
  @"Fujifilm/GFX50S II/Fuji_GFX50S_II_-_Compressed.RAF",
  @"Fujifilm/X-E4/fuji_xe4_32_lossy.RAF",
  @"Fujifilm/X-H2/Fuji-X-H2-Compressed-Raw.RAF",
  @"Fujifilm/X-H2S/IMG-20221005-0667.raf",
  @"Fujifilm/X-S10/Fujifilm-X-S10-compressed.RAF",
  @"Fujifilm/X-S20/DSCF2529.RAF",
  @"Fujifilm/X-T30 II/compressed_X-T30II.RAF",
  @"Fujifilm/X-T4/DSCF0268.RAF",
  @"Fujifilm/X-T5/DSCF0022.RAF",

  @"HASSELBLAD/Hasselblad H4D/A0000902.3FR",
  @"HASSELBLAD/Hasselblad H4D-40/Job_3583.fff",
  @"HASSELBLAD/Hasselblad H6D-100cMS/h6d400c_1shot_0007.fff",
  @"HASSELBLAD/Lunar/DSC00343.ARW",
  @"HASSELBLAD/L2D-20c/DJI_0023.DNG",

  @"Leica/V-LUX 4/L1040407.RWL",
  @"Leica/V-Lux 5/_1000200.RWL",

  @"OLYMPUS/SP510UZ/PA210583.ORF",
  @"OLYMPUS/SP565UZ/2019-09-26--10.03.53001.ORF",

  @"Sony/ILCE-6001/sony_tweak_a6001.ARW",
  @"Sony/ILCE-6700/DSC00001.ARW",
  @"Sony/ILCE-6700/DSC00002.ARW",
]];

- (void)test3FRDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"3FR"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)test3FRDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"3FR"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testARWDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ARW"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testARWDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ARW"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testAppleDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Apple"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testAppleDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Apple"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testCR2DecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR2"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testCR2DecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR2"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testCR3DecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR3"
                                      withDecoder:[RDLibRawDecoder self]];
}

// RawSpeed does not support CR3 :(
//- (void)testCR3DecodingWithRawSpeed {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"CR3"
//                                      withDecoder:[RDRawSpeedDecoder self]];
//}

- (void)testDJIDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"DJI"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testDJIDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"DJI"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testFFFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"FFF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testFFFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"FFF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

//- (void)testGPRDecodingWithLibRaw {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"GPR"
//                                      withDecoder:[RDLibRawDecoder self]];
//}

- (void)testGPRDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"GPR"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testGoogleDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Google"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testGoogleDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Google"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testHasselbladDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"HASSELBLAD"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testHasselbladDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"HASSELBLAD"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testIIQDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"IIQ"
                                      withDecoder:[RDLibRawDecoder self]];
}

// RawSpeed seems to support some IIQ files, but there are too many test failures here, so just
// ignore this test
//- (void)testIIQDecodingWithRawSpeed {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"IIQ"
//                                      withDecoder:[RDRawSpeedDecoder self]];
//}

- (void)testLeicaDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Leica"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testLeicaDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Leica"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testLeicaRAWDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
                                      inDirectory:@"Leica"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testLeicaRAWDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
                                      inDirectory:@"Leica"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testMDCDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"MDC"
                                      withDecoder:[RDLibRawDecoder self]];
}

// RawSpeed doesn't seem to support MDC
//- (void)testMDCDecodingWithRawSpeed {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"MDC"
//                                      withDecoder:[RDRawSpeedDecoder self]];
//}

- (void)testMRWDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"MRW"
                                      withDecoder:[RDLibRawDecoder self]];
}

// RawSpeed doesn't seem to support MRW
//- (void)testMRWDecodingWithRawSpeed {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"MRW"
//                                      withDecoder:[RDRawSpeedDecoder self]];
//}

- (void)testNEFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"NEF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testNEFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"NEF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testORFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testORFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testORIDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORI"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testORIDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"ORI"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testPEFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"PEF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testPEFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"PEF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testPentaxDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Pentax"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testPentaxDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Pentax"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testPentaxRAWDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
                                      inDirectory:@"Pentax"
                                      withDecoder:[RDLibRawDecoder self]];
}

// RawSpeed doesn't seem to support Pentax RAW file format
//- (void)testPentaxRAWDecodingWithRawSpeed {
//  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAW"
//                                      inDirectory:@"Pentax"
//                                      withDecoder:[RDRawSpeedDecoder self]];
//}

- (void)testRAFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testRAFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RAF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testRW2DecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RW2"
                                      withDecoder:[RDLibRawDecoder self]];
}

// Twenty failing files as I write this. I'm not going to add all these exceptions
// This test will fail
- (void)testRW2DecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RW2"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testRWLDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RWL"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testRWLDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"RWL"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testSR2DecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SR2"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testSR2DecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SR2"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testSRFDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRF"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testSRFDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRF"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testSRWDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRW"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testSRWDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"SRW"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testSamsungDNGDecodingWithLibRaw {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Samsung"
                                      withDecoder:[RDLibRawDecoder self]];
}

- (void)testSamsungDNGDecodingWithRawSpeed {
  [RawPixlsTests testDecodingOfFilesWithExtension:@"DNG"
                                      inDirectory:@"Samsung"
                                      withDecoder:[RDRawSpeedDecoder self]];
}

- (void)testCanonR8WithLibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:@"Canon/Canon EOS R8/CRAW_FULL_FRAME.CR3"
                                                             withDecoder:[RDLibRawDecoder self]];
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

- (void)testNikonD850WithRawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Nikon/D850/Nikon-D850-14bit-lossless-compressed.NEF"
                             withDecoder:[RDRawSpeedDecoder self]];
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

- (void)testSonyDSCR1WithRawSpeed {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Sony/DSC-R1/_DSC1477.SR2"
                             withDecoder:[RDRawSpeedDecoder self]];
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

+ (void)testDecodingOfFilesWithExtension:(NSString *)fileExtension
                             withDecoder:(id<RDRawImageDecoder>)decoder {
  [self testDecodingOfFilesWithExtension:fileExtension
                             inDirectory:@""
                             withDecoder:decoder];
}

+ (void)testDecodingOfFilesWithExtension:(NSString *)fileExtension
                             inDirectory:(NSString *)directory
                             withDecoder:(id<RDRawImageDecoder>)decoder {
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
      if (decoder == [RDLibRawDecoder self] && [knownFailingLibRawFiles containsObject:rawFilePath]) {
        continue;
      }
      if (decoder == [RDRawSpeedDecoder self] && [knownFailingRawSpeedFiles containsObject:rawFilePath]) {
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
    [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                     withDecoder:decoder];
  }
}

@end
