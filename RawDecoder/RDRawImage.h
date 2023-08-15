#ifndef RDRawImage_h
#define RDRawImage_h

#import <RawDecoder/RDCFA.h>
#import <RawDecoder/RDCFAColor.h>
#import <RawDecoder/RDRawImageMetadata.h>

NS_ASSUME_NONNULL_BEGIN

/// A raw image. Among other things, a raw image specifies a cropped and uncropped image.
/// Unqualified references to a raw image refer to its cropped image. References to the uncropped
/// image will be made explicit. For example, the height of the cropped image is specified by the
/// `height` property. The height of the uncropped image is specified by the `uncroppedHeight`
/// property
@protocol RDRawImage

/// An upper bound on the values of the decoded pixels. This will be at most 16, and is typically
/// 14—or 12 for older cameras. To be precise, this value is equal to
/// `(uint16_t)ceil(log2(self.whitePoint))`
@property (readonly) NSInteger bitsPerSample;
@property (readonly) NSInteger blackLevel;

/// The domain of values of decoded pixels, expressed in bytes. The current implementation assumes
/// a value of 2 bytes, i.e. 16-bits. Floating point raw files are not supported
@property (readonly) NSInteger bytesPerPixel;

/// Also called pitch
@property (readonly) NSInteger bytesPerRow;
@property (readonly) RDCFA    *cfa;
@property (readonly) NSArray<NSNumber *> *componentBlackLevels;

/// Color components per pixel. Supported raw files have one component per pixel. Typical full
/// color images would have 3 or 4 components per pixel, depending on the presence of an
/// alpha component
@property (readonly) NSInteger componentsPerPixel;

/// The horizontal offset of the sensor crop relative to the origin of the uncropped sensor image.
/// Note this offset is from the left side of the image
@property (readonly) NSInteger cropOriginX;

/// The vertical offset of the sensor crop relative to the origin of the uncropped sensor image.
/// Note this offset is from the top of the image
@property (readonly) NSInteger cropOriginY;

/// The cropped sensor image data, relative to the crop origin. Note, the black level has not been
/// subtracted from these values
@property (readonly) const uint16_t *imageData;

/// The height of the cropped sensor image
@property (readonly) NSInteger height;

/// The width of the cropped sensor image
@property (readonly) NSInteger width;
@property (readonly) RDRawImageMetadata *metadata;

/// The uncropped sensor image data, relative to the top left corner of the image. Note, the
/// black level has not been subtracted from these values
@property (readonly) const uint16_t *uncroppedImageData;

/// The height of the uncropped sensor image
@property (readonly) NSInteger uncroppedHeight;

/// The width of the uncropped sensor image
@property (readonly) NSInteger uncroppedWidth;
@property (readonly) NSInteger whitePoint;

/// The color at the given cropped image coordinates. Note, the crop origin is relative to the top
/// left of the image
/// - Parameters:
///   - x: the horizontal offset from the crop origin
///   - y: the vertical offset from the crop origin
- (RDCFAColor) colorAtX:(NSInteger)x
                      y:(NSInteger)y;

/// The pixel value at the given cropped image location. The first row is at the top of the cropped
/// image
/// - Parameters:
///   - row: the vertical offset from the crop origin
///   - col: the horizontal offset from the crop origin
- (uint16_t) valueAtRow:(NSInteger)row
                    col:(NSInteger)col;

/// The pixel value at the given uncropped image coordinates. The first row is at the top of the
/// uncropped image
/// - Parameters:
///   - row: the vertical offset from the uncropped image origin
///   - col: the horizontal offset from the uncropped image origin
- (uint16_t) valueAtUncroppedRow:(NSInteger)row
                             col:(NSInteger)col;
@end

NS_ASSUME_NONNULL_END

#endif /* RDRawImage_h */
