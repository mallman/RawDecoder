#import "RDErrorDomain.h"
#import "RDError+Private.h"

const NSErrorDomain _Nonnull RDErrorDomain = @"RDErrorDomain";

const NSErrorUserInfoKey _Nonnull RDBackendErrorCodeKey = @"RDBackendErrorCode";

void RDSetError(NSError * _Nullable __autoreleasing * _Nullable error,
                RDErrorCode code,
                NSString *message,
                NSNumber * _Nullable backendCode) {
  if (error == NULL) {
    return;
  }
  NSMutableDictionary<NSErrorUserInfoKey, id> *userInfo = [NSMutableDictionary dictionary];
  userInfo[NSLocalizedDescriptionKey] = message;
  if (backendCode != nil) {
    userInfo[RDBackendErrorCodeKey] = backendCode;
  }
  *error = [NSError errorWithDomain:RDErrorDomain code:code userInfo:userInfo];
}
