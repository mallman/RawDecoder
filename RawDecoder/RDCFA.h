#import <Foundation/Foundation.h>

#import <RawDecoder/RDCFAColor.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// An abstract representation of a Color Filter Array. A CFA tiles the pixel array of a sensor
/// with a repeating pattern. See
/// https://en.wikipedia.org/wiki/Color_filter_array for more information
@interface RDCFA: NSObject

/// The height of the CFA
@property (readonly) NSInteger height;

/// The width of the CFA
@property (readonly) NSInteger width;

/// An array of numbers representing TIFF/EXIF colors from the TIFF/EXIF tag 0xA302, where
/// the color at (x, y) is given by exifCFAPattern[x + y * width]. Note that the origin of this
/// coordinate system is at the top left corner of the CFA pattern
@property (readonly) NSArray<NSNumber*> *exifCFAPattern;

- (instancetype)init NS_UNAVAILABLE;

/// Returns the CFA color at (x, y), where (0, 0) is at the top left corner of the CFA
/// - Parameters:
///   - x: the x offset
///   - y: the y offset
- (RDCFAColor) colorAtX:(NSInteger)x
                      y:(NSInteger)y;

@end

NS_ASSUME_NONNULL_END
