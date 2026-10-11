#ifndef RDError_Private_h
#define RDError_Private_h

#import "RDErrorDomain.h"

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif

/// Sets `*error` to an `RDErrorDomain` error. Does nothing when `error` is NULL, which
/// callers are allowed to pass
void RDSetError(NSError * _Nullable __autoreleasing * _Nullable error,
                RDErrorCode code,
                NSString *message,
                NSNumber * _Nullable backendCode);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END

#endif /* RDError_Private_h */
