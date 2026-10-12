#ifndef RDErrorDomain_h
#define RDErrorDomain_h

#import <Foundation/Foundation.h>

extern const NSErrorDomain _Nonnull RDErrorDomain;

/// userInfo key holding the decoding backend's own error code as an `NSNumber`, when the
/// backend has one. For LibRaw this is the return value of `libraw_open_*` or `libraw_unpack`.
/// RawSpeed reports failures as C++ exceptions and has no numeric code, so the key is absent
extern const NSErrorUserInfoKey _Nonnull RDBackendErrorCodeKey;

/// Error codes in `RDErrorDomain`. The localized description carries the backend's message
typedef NS_ERROR_ENUM(RDErrorDomain, RDErrorCode) {
  /// The backend could not open or identify the file: unreadable, truncated, or a format it
  /// does not support
  RDErrorCodeOpenFailed = 1,

  /// The file was identified but its raw data could not be unpacked
  RDErrorCodeUnpackFailed = 2,

  /// The image has a color filter array this framework does not support
  RDErrorCodeUnsupportedCFA = 3,

  /// The image has no color filter array, e.g. a linear DNG or a monochrome sensor
  RDErrorCodeNoCFA = 4,

  /// The backend failed while decoding. RawSpeed reports every failure this way
  RDErrorCodeDecodeFailed = 5,

  /// The decoded image is not one 16-bit component per pixel, e.g. a floating-point DNG
  RDErrorCodeUnsupportedPixelFormat = 6,
};

#endif /* RDErrorDomain_h */
