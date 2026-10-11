#import <Foundation/Foundation.h>
#import <libraw.h>

NS_ASSUME_NONNULL_BEGIN

/// Captures the TIFF/EXIF `Make` (0x010f) and `Model` (0x0110) tags exactly as written in the
/// file, by observing the tags LibRaw walks during `libraw_open_*`. LibRaw rewrites its own
/// `idata.make`/`idata.model` ("NIKON CORPORATION" becomes "Nikon") and keeps no copy of the
/// originals, so this is the only way to get them. Costs nothing measurable: it piggybacks on
/// the parse LibRaw performs anyway.
///
/// Containers without a TIFF structure (CIFF-based CRW, MDC) never trigger the callback, and
/// both properties stay nil.
@interface LibRawExifCapture: NSObject

/// The `Make` tag, trimmed of TIFF padding, or nil if none was seen
@property (readonly, nullable) NSString *make;

/// The `Model` tag, trimmed of TIFF padding, or nil if none was seen
@property (readonly, nullable) NSString *model;

/// Installs the receiver as `librawData`'s EXIF parser handler. Call before `libraw_open_*`.
/// The receiver must outlive the open call
- (void)installOnLibrawData:(libraw_data_t *)librawData;

/// Removes the handler. Call after `libraw_open_*` returns, so later LibRaw calls cannot
/// reach a released receiver
- (void)uninstallFromLibrawData:(libraw_data_t *)librawData;

@end

NS_ASSUME_NONNULL_END
