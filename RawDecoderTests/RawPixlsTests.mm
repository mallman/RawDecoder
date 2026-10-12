#import <XCTest/XCTest.h>

#import <RawDecoder/RawDecoder.h>

#import "RawDecoderTestUtils.h"

@interface RawPixlsTests: XCTestCase
@end

@implementation RawPixlsTests

static NSSet<NSString *> *knownFailingFiles = [NSSet setWithArray: @[
  @"Apple/iPhone 12 Pro/IMG_1361.DNG",

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
  @"Canon/EOS 7D Mark II/capture000107.cr2",
  @"Canon/EOS 7D Mark II/capture000108.cr2",
  @"Canon/EOS 7D/RAW_CANON_EOS_7D-mraw.CR2",
  @"Canon/EOS 7D/RAW_CANON_EOS_7D-sraw.CR2",
  @"Canon/EOS 80D/IMG_0096.CR2",
  @"Canon/EOS 80D/IMG_0097.CR2",
  @"Canon/EOS-1D Mark IV/IMG_5395.CR2",
  @"Canon/EOS-1D Mark IV/IMG_5398.CR2",
  @"Canon/EOS-1D X Mark II/AZ1I2271.CR2",
  @"Canon/EOS-1D X Mark II/AZ1I2272.CR2",

  @"Fujifilm/DBP for GX680/DSCF0010.RAF",

  @"Leica/M Monochrom (Typ 246)/M2462362.DNG",
  @"Leica/M Monochrom/L1000622.DNG",

  @"Nikon/D4S/FU9_3802.NEF",
  @"Nikon/D810/DSC_1888.NEF",
  @"Nikon/Nikon COOLSCAN IV ED/NEF_from_Nikon_Scan_4.0.3_at_600dpi.nef",
  @"Nikon/Nikon COOLSCAN V ED/Image21-600pixels.nef",
  @"Nikon/Z 8/Nikon_Z8_high_efficiency_low.NEF",
  @"Nikon/Z 8/Nikon_Z8_raw_high_efficiency_hight.NEF",
  @"Nikon/Z 9/Nikon_-_NIKON_Z_9_-_14bit_compressed_(Lossy_High_Efficiency).NEF",
  @"Nikon/Z 9/Nikon_-_NIKON_Z_9_-_14bit_compressed_(Lossy_High_Efficiency_Star).NEF",
  @"Nikon/Z f/DSC_0042.NEF",
  @"Nikon/Z f/DSC_0043.NEF",

  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_16_9.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_1_1.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_DX.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_FX.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_Star_16_9.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_Star_1_1.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_Star_DX.NEF",
  @"NIKON CORPORATION/NIKON Z6_3/Nikon_Z6__3_High_Efficiency_Star_FX.NEF",

  @"Pentax/K-3 Mark III Monochrome/K3III.DNG",
  @"Pentax/K-3 Mark III Monochrome/K3III.PEF",

  @"Samsung/Galaxy S21 Ultra/20230712_115041.dng",
  @"Samsung/Galaxy S22 Ulra/20221225_114402.dng",
  @"Samsung/Galaxy S22 Ultra/20230531_111518.dng",
  @"Samsung/Galaxy S23 Ultra/20230228_163710.dng",
  @"Samsung/Galaxy S23 Ultra/20230817_120455.dng",
  @"Samsung/Galaxy S23 Ultra/20231214_130645.dng",
  @"Samsung/Galaxy S23+/20231227_172938.dng",
  @"Samsung/Galaxy S23/20230414_115131.dng",
  @"Samsung/Galaxy S23/20230715_154550.dng",
  @"Samsung/SM-G973U/20200402_181931.dng",
  @"Samsung/SM-S908U/20221120_114119.dng",

  @"SONY/DSC-RX1RM3/DSC00255.ARW",
  @"SONY/DSC-RX1RM3/DSC00256.ARW",
  @"SONY/ILCE-1M2/A1_07628_lossless_compressed_medium_full_frame.ARW",
  @"SONY/ILCE-1M2/A1_07629_lossless_compressed_small_full_frame.ARW",
  @"SONY/ILCE-1M2/A1_07633_lossless_compressed_small_apsc.ARW",
  @"Sony/ILCE-7CR/DSC00796.ARW",
  @"Sony/ILCE-7CR/DSC00797.ARW",
  @"Sony/ILCE-7CR/DSC00800.ARW",
  @"Sony/ILCE-7M4/ILCE-7M4_DSC06675_FullFrame-LossLess-Compressed-Medium.ARW",
  @"Sony/ILCE-7M4/ILCE-7M4_DSC06676_FullFrame-LossLess-Compressed-Small.ARW",
  @"Sony/ILCE-7M4/ILCE-7M4_DSC06680_APS-C-LossLess-Small.ARW",
  @"SONY/ILCE-7M5/apcs_compressed_hq.ARW",
  @"SONY/ILCE-7M5/apsc_compressed.ARW",
  @"SONY/ILCE-7M5/full_compressed.ARW",
  @"SONY/ILCE-7M5/full_compressed_HQ.ARW",
  @"Sony/ILCE-7RM5/7RM5-LosslessCompressedMedium.ARW",
  @"Sony/ILCE-7RM5/7RM5-LosslessCompressedSmall.ARW",
  @"Sony/ILCE-7RM5/7RM5-S35-LosslessCompressedSmall.ARW",
  @"Sony/ILCE-9M3/DSC00113.ARW",
  @"Sony/ILCE-9M3/DSC00114.ARW",
  @"Sony/ILCE-9M3/DSC00118.ARW",
  @"SONY/ILME-FX2/Image_4_-_Lossless_Compression_(M)_-_Shade.ARW",
  @"SONY/ILME-FX2/Image_5_-_Lossless_Compression_(S)_-_Shade.ARW",
]];

static NSSet<NSString *> *knownFailingLibRawFiles = [NSSet setWithArray: @[
  @"Fujifilm/FinePix E550/RAW_FUJI_E550.RAF",
  @"Fujifilm/FinePix E900/RAW_FUJI_E900.RAF",
  @"Fujifilm/FinePix F700/RAW_FUJI_F700.RAF",
  @"Fujifilm/FinePix S100FS/DSCF8410.RAF",
  @"Fujifilm/FinePix S2Pro/DSCF0002.RAF",
  @"Fujifilm/FinePix S3Pro/DSCF3694.RAF",
  @"Fujifilm/FinePix S5000/2007_0912Image0022.RAF",
  @"Fujifilm/FinePix S5200/DSCF1523.RAF",
  @"Fujifilm/FinePix S5600/RAW_FUJI_S5600S5200.RAF",
  @"Fujifilm/FinePix S5Pro/2018_06150003.RAF",
  @"Fujifilm/FinePix S6000fd/DSCF1973.RAF",
  @"Fujifilm/FinePix S6500fd/DSCF1333.RAF",
  @"Fujifilm/FinePix S7000/dscf3648.raf",
  @"Fujifilm/FinePix S9500/20170430_0041.RAF",
  @"Fujifilm/FinePix S9600/2007-11-10--16-32-45-original.raf",

  @"Nikon/E5700/20080115-DSCN1758.NEF",

  @"Panasonic/DC-S1RM2/P1000450.RW2",

  @"Sony/DSC-F828/DSC06227.SRF",
]];

static NSSet<NSString *> *knownFailingRawSpeedFiles = [NSSet setWithArray: @[
  @"Canon/PowerShot SX40 HS/CRW_6036.CR2",
  @"Canon/SX150IS/CRW_1762.CR2",

  @"DJI/FC4382/DJI_20250506184749_0011_D.DNG",
  @"DJI/FC9287/DJI_20250528104510_0025_D.DNG",

  @"Fujifilm/GFX100 II/_DSF0265.RAF",
  @"Fujifilm/GFX100 II/_DSF0266.RAF",
  @"FUJIFILM/GFX100RF/DSCF0076.RAF",
  @"FUJIFILM/GFX100RF/DSCF0092.RAF",
  @"FUJIFILM/GFX100S II/_DSF0002.RAF",
  @"FUJIFILM/GFX100S II/_DSF0006.RAF",
  @"Fujifilm/GFX100S/Fujifilm-GFX100S-14bits-compress-4_3.RAF",
  @"Fujifilm/GFX100S/Fujifilm-GFX100S-16bits-compress-4_3.RAF",
  @"Fujifilm/GFX50S II/Fuji_GFX50S_II_-_Compressed.RAF",
  @"Fujifilm/X-E4/fuji_xe4_32_lossy.RAF",
  @"FUJIFILM/X-E5/DSCF0204.RAF",
  @"Fujifilm/X-H2/Fuji-X-H2-Compressed-Raw.RAF",
  @"Fujifilm/X-H2S/IMG-20221005-0667.raf",
  @"FUJIFILM/X-M5/DSCF0622_-_compressed.RAF",
  @"Fujifilm/X-S10/Fujifilm-X-S10-compressed.RAF",
  @"Fujifilm/X-S20/DSCF2529.RAF",
  @"Fujifilm/X-T30 II/compressed_X-T30II.RAF",
  @"FUJIFILM/X-T30 III/DSCF0131.RAF",
  @"FUJIFILM/X-T30 III/DSCF0132.RAF",
  @"FUJIFILM/X-T30 III/DSCF0133.RAF",
  @"Fujifilm/X-T4/DSCF0268.RAF",
  @"Fujifilm/X-T5/DSCF0022.RAF",
  @"FUJIFILM/X-T50/DSCF0120.RAF",
  @"Fujifilm/X100VI/DSCF0076.RAF",

  @"Hasselblad/Hasselblad H4D-40/Job_3583.fff",
  @"Hasselblad/Hasselblad H6D-100cMS/h6d400c_1shot_0007.fff",
  @"Hasselblad/L2D-20c/DJI_0023.DNG",
  @"HASSELBLAD/Lunar/DSC00343.ARW",

  @"Nikon/Coolpix E8800/DSCN6207.NEF",
  @"Nikon/E8400/DSCN1565.NEF",

  @"NIKON CORPORATION/NIKON Z50_2/DSC_0061_DX_HE_Star.NEF",
  @"NIKON CORPORATION/NIKON Z50_2/DSC_0062_DX_HE.NEF",
  @"NIKON CORPORATION/NIKON Z50_2/DSC_0064_1x1_HE_Star.NEF",
  @"NIKON CORPORATION/NIKON Z50_2/DSC_0065_1x1_HE.NEF",
  @"NIKON CORPORATION/NIKON Z50_2/DSC_0067_16x9_HE_Star.NEF",
  @"NIKON CORPORATION/NIKON Z50_2/DSC_0068_16x9_HE.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_1-1.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_16-9.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_DX.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_FX_1.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_Star_1-1.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_Star_16-9.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_Star_DX.NEF",
  @"NIKON CORPORATION/NIKON Z5_2/High_Efficiency_Star_FX_1.NEF",

  @"Panasonic/DC-FZ45/P1000336.RW2",
  @"Panasonic/DC-TZ200D/TZ200D_16_9_1000230.RW2",
  @"Panasonic/DC-TZ200D/TZ200D_1_1_1000231.RW2",
  @"Panasonic/DC-TZ200D/TZ200D_3_2_1000232.RW2",
  @"Panasonic/DC-TZ200D/TZ200D_4_3_1000233.RW2",
  @"Panasonic/DC-ZS200D/P1000631.RW2",
  @"Panasonic/DC-ZS200D/P1000632.RW2",
  @"Panasonic/DC-ZS200D/P1000633.RW2",
  @"Panasonic/DC-ZS200D/P1000634.RW2",
  @"Panasonic/DMC-CM1/_1010508_4:3.RW2",
  @"Panasonic/DMC-CM1/_1010510_16:9.RW2",
  @"Panasonic/DMC-CM1/_1010511_1:1.RW2",
  @"Panasonic/DMC-GH1/P1040799.RW2",

  @"Sony/ILCE-6001/sony_tweak_a6001.ARW",
  @"SONY/ILCE-7M5/apsc_compressed_lossless.ARW",
  @"SONY/ILCE-7M5/full_compressed_lossless.ARW",
  @"SONY/ILME-FX2/Image_1_-_Uncompressed_-_Landscape.ARW",
  @"SONY/ILME-FX2/Image_2_-_Compressed_-_Architecture.ARW",
  @"SONY/ILME-FX2/Image_3_-_Lossless_Compression_(L)_-_Shade.ARW",
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
  id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:@"Canon/EOS R8/CRAW_FULL_FRAME.CR3"
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
  XCTAssertEqual(rawImage.uncroppedWidth, 6188);
  XCTAssertEqual(rawImage.uncroppedHeight, 4120);

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

  XCTAssertEqualObjects(rawImage.blackLevel, @512);
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
  XCTAssertEqualObjects(metadata.cameraModel, @"Canon EOS R8");
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

  XCTAssertEqualObjects(rawImage.blackLevel, @400);
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

  XCTAssertEqualObjects(rawImage.blackLevel, @511);
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

/// This SR2 carries no linear_max, so LibRaw's white point must come from its fallback
/// rather than being 0. RawSpeed reports 16383 for the same file. It also has per-channel
/// black levels, which LibRaw reads and RawSpeed does not
- (void)testSonyDSCR1WhitePointWithLibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Sony/DSC-R1/_DSC1477.SR2"
                             withDecoder:[RDLibRawDecoder self]];
  if (rawImage == nil) {
    return;
  }

  XCTAssertEqual(rawImage.whitePoint, 16383);
  XCTAssertEqual(rawImage.bitsPerSample, 14);
  // LibRaw reads per-channel offsets 3, 0, 1, 2 (R, G, B, G2) on top of 511 from this SR2,
  // so the four CFA positions differ and there is no single black level. The CFA is GRBG
  XCTAssertNil(rawImage.blackLevel);
  NSArray<NSNumber *> *expectedComponentBlackLevels = @[@511, @514, @512, @513];
  XCTAssertEqualObjects(rawImage.componentBlackLevels, expectedComponentBlackLevels);
  XCTAssertGreaterThan(rawImage.whitePoint, 514);
}

/// For every X-Trans RAF both decoders read, the CFA color at each sensor position agrees.
/// The decoders crop differently, so compare at uncropped coordinates over a 12x12 window
/// inside both crops. This checks LibRaw's 6x6 pattern and its alignment against RawSpeed's
- (void)testXTransCFAMatchesRawSpeed {
  NSString *root = [RawDecoderTestUtils rawPixlsDataPath];
  NSArray<NSString *> *paths = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:root error:NULL]
                                sortedArrayUsingSelector:@selector(compare:)];
  NSInteger compared = 0;
  for (NSString *path in paths) {
    if (![path.pathExtension.lowercaseString isEqualToString:@"raf"]) {
      continue;
    }
    NSURL *url = [NSURL fileURLWithPath:[root stringByAppendingPathComponent:path]];
    id<RDRawImage> libRaw = [RDLibRawDecoder decodeRawImageFromFileURL:url error:NULL];
    if (libRaw == nil || libRaw.cfa.width != 6) {
      continue;
    }
    id<RDRawImage> rawSpeed = [RDRawSpeedDecoder decodeRawImageFromFileURL:url error:NULL];
    if (rawSpeed == nil) {
      continue;
    }
    XCTAssertEqual(rawSpeed.cfa.width, 6, @"RawSpeed CFA width: %@", path);
    NSInteger originX = MAX(libRaw.cropOriginX, rawSpeed.cropOriginX);
    NSInteger originY = MAX(libRaw.cropOriginY, rawSpeed.cropOriginY);
    NSInteger mismatches = 0;
    for (NSInteger y = originY; y < originY + 12; y++) {
      for (NSInteger x = originX; x < originX + 12; x++) {
        if ([libRaw colorAtX:x - libRaw.cropOriginX y:y - libRaw.cropOriginY] !=
            [rawSpeed colorAtX:x - rawSpeed.cropOriginX y:y - rawSpeed.cropOriginY]) {
          mismatches++;
        }
      }
    }
    XCTAssertEqual(mismatches, 0, @"X-Trans CFA differs between decoders at %ld of 144 positions: %@",
                   (long)mismatches, path);
    compared++;
  }
  NSLog(@"X-Trans files compared across decoders: %ld", (long)compared);
  XCTAssertGreaterThan(compared, 0);
}

/// RawSpeed decodes this HDRMerge DNG to 32-bit floats, which the API cannot represent, so it
/// must refuse it rather than hand out float bytes as uint16 samples. LibRaw converts floating
/// point DNGs to 16-bit integers during unpack, so it decodes the same file
- (void)testFloatingPointDNGPixelFormat {
  NSString *path = @"Canon/EOS 5D Mark III/hdrmerge-bayer-fp32-uncompressed.dng";
  NSURL *url = [NSURL fileURLWithPath:[[RawDecoderTestUtils rawPixlsDataPath] stringByAppendingPathComponent:path]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
    return;
  }

  NSError *error = nil;
  XCTAssertNil([RDRawSpeedDecoder decodeRawImageFromFileURL:url error:&error]);
  XCTAssertEqualObjects(error.domain, RDErrorDomain);
  XCTAssertEqual(error.code, RDErrorCodeUnsupportedPixelFormat);

  id<RDRawImage> libRawImage = [RDLibRawDecoder decodeRawImageFromFileURL:url error:NULL];
  XCTAssertNotNil(libRawImage);
  XCTAssertEqual(libRawImage.bytesPerPixel, 2);
  XCTAssertEqual(libRawImage.componentsPerPixel, 1);
}

/// LibRaw 0.22.2 reads a linear_max of 153 for this body, below its black level of 511, so the
/// white point must come from the fallback (LibRaw's maximum, 16383)
- (void)testCanonR50VWhitePointWithLibRaw {
  id<RDRawImage> rawImage = [RawDecoderTestUtils
                             rawImageAtPixlsFilePath:@"Canon/Canon EOS R50 V/IMG_0034.CR3"
                             withDecoder:[RDLibRawDecoder self]];
  if (rawImage == nil) {
    return;
  }

  XCTAssertEqualObjects(rawImage.blackLevel, @511);
  XCTAssertEqual(rawImage.whitePoint, 16383);
  XCTAssertEqual(rawImage.bitsPerSample, 14);
}

/// This CRW records no as-shot white balance. Both decoders must say so with nil
- (void)testCanonS3ISCRWHasNoWhiteBalance {
  NSString *path = @"Canon/Poweshot S3IS/RAW_CANON_S3IS.CRW";
  id<RDRawImage> libRawImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                                                withDecoder:[RDLibRawDecoder self]];
  id<RDRawImage> rawSpeedImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                                                  withDecoder:[RDRawSpeedDecoder self]];
  if (libRawImage == nil || rawSpeedImage == nil) {
    return;
  }

  XCTAssertNil(libRawImage.metadata.whiteBalanceCoefficients);
  XCTAssertNil(rawSpeedImage.metadata.whiteBalanceCoefficients);
}

/// CIFF-based CRW files carry no TIFF Make/Model tags. LibRaw can only offer its rewritten
/// strings, so the LibRaw decoder returns nil; RawSpeed reads CIFF's own make/model record.
/// The canonical fields agree regardless
- (void)testCanonS70CRWMakeModel {
  NSString *path = @"Canon/PowerShot S70/RAW_CANON_S70_SRGB.CRW";
  id<RDRawImage> libRawImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                                                withDecoder:[RDLibRawDecoder self]];
  id<RDRawImage> rawSpeedImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                                                  withDecoder:[RDRawSpeedDecoder self]];
  if (libRawImage == nil || rawSpeedImage == nil) {
    return;
  }

  XCTAssertNil(libRawImage.metadata.cameraMake);
  XCTAssertNil(libRawImage.metadata.cameraModel);
  XCTAssertEqualObjects(rawSpeedImage.metadata.cameraMake, @"Canon");
  XCTAssertEqualObjects(rawSpeedImage.metadata.cameraModel, @"Canon PowerShot S70");

  XCTAssertEqualObjects(libRawImage.metadata.canonicalCameraMake, rawSpeedImage.metadata.canonicalCameraMake);
  XCTAssertEqualObjects(libRawImage.metadata.canonicalCameraModel, rawSpeedImage.metadata.canonicalCameraModel);
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
    id<RDRawImage> rawImage = [RawDecoderTestUtils rawImageAtPixlsFilePath:path
                                                                withDecoder:decoder];
    if (rawImage != nil) {
      [self checkInvariantsOfRawImage:rawImage path:path decoder:decoder];
    }
  }
}

/// Properties every decoded image must satisfy regardless of camera or decoder. Each failure
/// message starts with "invariant" and names the decoder and file, so a dataset run can be
/// filtered to them
+ (void)checkInvariantsOfRawImage:(id<RDRawImage>)rawImage
                             path:(NSString *)path
                          decoder:(id<RDRawImageDecoder>)decoder {
  NSString *who = [NSString stringWithFormat:@"%@ %@", NSStringFromClass((Class)decoder), path];

  // Geometry: the crop lies inside the uncropped image (review B1)
  XCTAssertGreaterThan(rawImage.width, 0, @"invariant width > 0: %@", who);
  XCTAssertGreaterThan(rawImage.height, 0, @"invariant height > 0: %@", who);
  XCTAssertGreaterThanOrEqual(rawImage.cropOriginX, 0, @"invariant cropOriginX >= 0: %@", who);
  XCTAssertGreaterThanOrEqual(rawImage.cropOriginY, 0, @"invariant cropOriginY >= 0: %@", who);
  XCTAssertLessThanOrEqual(rawImage.cropOriginX + rawImage.width, rawImage.uncroppedWidth,
                           @"invariant crop within uncropped width: %@", who);
  XCTAssertLessThanOrEqual(rawImage.cropOriginY + rawImage.height, rawImage.uncroppedHeight,
                           @"invariant crop within uncropped height: %@", who);

  // Pixel format: 16-bit, one component, rows at least one row of pixels wide (review A8)
  XCTAssertEqual(rawImage.bytesPerPixel, 2, @"invariant bytesPerPixel == 2: %@", who);
  XCTAssertEqual(rawImage.componentsPerPixel, 1, @"invariant componentsPerPixel == 1: %@", who);
  XCTAssertGreaterThanOrEqual(rawImage.bytesPerRow, rawImage.uncroppedWidth * rawImage.bytesPerPixel,
                              @"invariant bytesPerRow >= row of pixels: %@", who);

  // Levels: a usable range between black and white (review B2)
  NSArray<NSNumber *> *levels = rawImage.componentBlackLevels;
  NSNumber *maxLevel = [levels valueForKeyPath:@"@max.self"];
  NSNumber *minLevel = [levels valueForKeyPath:@"@min.self"];
  XCTAssertGreaterThanOrEqual(minLevel.integerValue, 0, @"invariant componentBlackLevels >= 0: %@", who);
  XCTAssertGreaterThan(rawImage.whitePoint, maxLevel.integerValue, @"invariant whitePoint > blackLevel: %@", who);
  if ([minLevel isEqual:maxLevel]) {
    XCTAssertEqualObjects(rawImage.blackLevel, minLevel, @"invariant uniform components give blackLevel: %@", who);
  } else {
    XCTAssertNil(rawImage.blackLevel, @"invariant differing components give nil blackLevel: %@", who);
  }
  XCTAssertGreaterThanOrEqual(rawImage.bitsPerSample, 8, @"invariant bitsPerSample >= 8: %@", who);
  XCTAssertLessThanOrEqual(rawImage.bitsPerSample, 16, @"invariant bitsPerSample <= 16: %@", who);
  XCTAssertEqual(rawImage.componentBlackLevels.count, 4u, @"invariant 4 componentBlackLevels: %@", who);

  // CFA: the image's per-pixel color agrees with its declared pattern (review B3). A 16x16
  // window covers Bayer (2x2), X-Trans (6x6) and LibRaw's 16x16 Leaf/Kodak table
  RDCFA *cfa = rawImage.cfa;
  XCTAssertEqual((NSUInteger)(cfa.width * cfa.height), cfa.exifCFAPattern.count,
                 @"invariant CFA size matches exifCFAPattern: %@", who);
  if (cfa.width > 0 && cfa.height > 0) {
    NSInteger mismatches = 0;
    for (NSInteger y = 0; y < MIN(16, rawImage.height); y++) {
      for (NSInteger x = 0; x < MIN(16, rawImage.width); x++) {
        if ([rawImage colorAtX:x y:y] != [cfa colorAtX:x % cfa.width y:y % cfa.height]) {
          mismatches++;
        }
      }
    }
    XCTAssertEqual(mismatches, 0, @"invariant colorAtX:y: agrees with cfa (%ldx%ld): %@",
                   (long)cfa.width, (long)cfa.height, who);
  }
}

@end
