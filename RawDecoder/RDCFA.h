#import <Foundation/Foundation.h>

#import <RawDecoder/RDCFAColor.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
/// An abstract representation of a Color Filter Array. A CFA tiles the pixel array of a sensor
/// with a repeating pattern. See
/// https://en.wikipedia.org/wiki/Color_filter_array for more information
@interface RDCFA: NSObject

/// The height of the CFA pattern in pixels: 2 for most Bayer sensors, 6 for Fujifilm X-Trans,
/// 8 or 16 for a few others
@property (readonly) NSInteger height;

/// The width of the CFA pattern in pixels: 2 for Bayer sensors, 6 for Fujifilm X-Trans, 16 for
/// some Leaf and Kodak backs
@property (readonly) NSInteger width;

/// An array of numbers representing TIFF/EXIF colors from the TIFF/EXIF tag 0xA302, where
/// the color at (x, y) is given by exifCFAPattern[x + y * width]. It has width * height
/// entries. Note that the origin of this coordinate system is at the top left corner of the CFA
/// pattern
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
