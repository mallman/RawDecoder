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
@protocol RDRawImage <NSObject>

/// An upper bound on the values of the decoded pixels. This will be at most 16, and is typically
/// 14—or 12 for older cameras. To be precise, this value is equal to
/// `(uint16_t)ceil(log2(self.whitePoint))`
@property (readonly) NSInteger bitsPerSample;

/// The black level shared by every CFA position, or nil when the positions have different
/// black levels. Use `componentBlackLevels`, which is always exact, when this is nil. Decoders
/// can disagree: one may read per-channel levels from the file where the other uses a single
/// per-camera value
@property (readonly, nullable) NSNumber *blackLevel;

/// The size of one decoded pixel in bytes. Always 2: pixels are 16-bit unsigned integers.
/// Decoding fails with `RDErrorCodeUnsupportedPixelFormat` for anything else, such as a
/// floating-point DNG
@property (readonly) NSInteger bytesPerPixel;

/// Also called pitch
@property (readonly) NSInteger bytesPerRow;
/// The color filter array pattern, starting at the crop origin. It is not always 2x2: Fujifilm
/// X-Trans sensors have a 6x6 pattern, some Leaf and Kodak backs a 16x16 one, and a few Bayer
/// sensors repeat only every 8 rows. Index it by `cfa.width` and `cfa.height`, never by 2
@property (readonly) RDCFA    *cfa;

/// The black level for each position of the 2x2 tile at the crop origin, always four values.
/// `componentBlackLevels[x + 2 * y]` belongs to the pixels at cropped coordinates whose
/// `(col % 2, row % 2)` is `(x, y)`, the same frame as `cfa`, `colorAtX:y:` and `imageData`.
/// This is the authoritative black level; subtract it per pixel
@property (readonly) NSArray<NSNumber *> *componentBlackLevels;

/// Color components per pixel. Always 1: each pixel holds one sample, whose color is given by
/// `cfa`. Images with several components per pixel (Canon sRAW/mRAW, linear DNGs) are rejected
/// with `RDErrorCodeNoCFA` or `RDErrorCodeUnsupportedPixelFormat`
@property (readonly) NSInteger componentsPerPixel;

/// The horizontal offset of the sensor crop relative to the origin of the uncropped sensor image.
/// Note this offset is from the left side of the image
@property (readonly) NSInteger cropOriginX;

/// The vertical offset of the sensor crop relative to the origin of the uncropped sensor image.
/// Note this offset is from the top of the image
@property (readonly) NSInteger cropOriginY;

/// The cropped sensor image data, relative to the crop origin. The value at (row, col) is
/// `imageData[col + row * bytesPerRow / 2]`.
///
/// Note, the black level has not been subtracted from these values
@property (readonly) const uint16_t *imageData;

/// The height of the cropped sensor image
@property (readonly) NSInteger height;

/// The width of the cropped sensor image
@property (readonly) NSInteger width;
@property (readonly) RDRawImageMetadata *metadata;

/// The uncropped sensor image data, relative to the top left corner of the image. The value at
/// (row, col) is `uncroppedImageData[col + row * bytesPerRow / 2]`.
///
/// Note, the black level has not been subtracted from these values
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
