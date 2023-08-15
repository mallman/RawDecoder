#import <Foundation/Foundation.h>

/// RDCFAColor mirrors the color identification codes from the TIFF/EXIF tag CFAPattern, 0xA302
typedef NS_ENUM(NSInteger, RDCFAColor) {
  RDCFAColorRed = 0,
  RDCFAColorGreen,
  RDCFAColorBlue,
  RDCFAColorCyan,
  RDCFAColorMagenta,
  RDCFAColorYellow,
  RDCFAColorWhite,
  RDCFAColorUnknown = 255
};
