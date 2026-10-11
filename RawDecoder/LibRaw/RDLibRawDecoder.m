#import "RDLibRawDecoder.h"
#import "LibRawRawImage.h"
#import "LibRawExifCapture.h"

#import "../RDErrorDomain.h"

#import <libraw.h>

@implementation RDLibRawDecoder

+ (void) setErrorWithMessage:(NSString *)errorMessage
                       error:(NSError * _Nullable __autoreleasing *)error {
  int errCode = -1;
  NSDictionary *errorDictionary = @{
    NSLocalizedDescriptionKey: errorMessage
  };
  *error = [NSError errorWithDomain:RDErrorDomain
                               code:errCode
                           userInfo:errorDictionary];
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromData:(nonnull const NSData *)data
                                             error:(NSError * _Nullable __autoreleasing *)error {
  libraw_data_t *librawData = libraw_init(0);
  LibRawExifCapture *exif = [LibRawExifCapture new];
  [exif installOnLibrawData:librawData];
  int rc = libraw_open_buffer(librawData, (const uint8_t *)data.bytes, (uint32_t)data.length);
  [exif uninstallFromLibrawData:librawData];
  if (rc != LIBRAW_SUCCESS) {
    [self setErrorWithMessage:[NSString stringWithFormat:@"libraw_open_buffer failed with error code: %d", rc]
                        error:error];
    return nil;
  }
  LibRawRawImage *rawImage = [[LibRawRawImage alloc] initFromLibrawData:librawData
                                                               exifMake:exif.make
                                                              exifModel:exif.model
                                                                  error:error];
  if (rawImage == nil) {
    libraw_close(librawData);
  }
  return rawImage;
}

+ (id<RDRawImage> _Nullable)decodeRawImageFromFileURL:(nonnull const NSURL *)fileURL
                                                error:(NSError * _Nullable __autoreleasing *)error {
  libraw_data_t *librawData = libraw_init(0);
  const char *rawFilePath = [[fileURL path] UTF8String];
  LibRawExifCapture *exif = [LibRawExifCapture new];
  [exif installOnLibrawData:librawData];
  int rc = libraw_open_file(librawData, rawFilePath);
  [exif uninstallFromLibrawData:librawData];
  if (rc != LIBRAW_SUCCESS) {
    [self setErrorWithMessage:[NSString stringWithFormat:@"libraw_open_file failed with error code: %d", rc]
                        error:error];
    return nil;
  }
  LibRawRawImage *rawImage = [[LibRawRawImage alloc] initFromLibrawData:librawData
                                                               exifMake:exif.make
                                                              exifModel:exif.model
                                                                  error:error];
  if (rawImage == nil) {
    libraw_close(librawData);
  }
  return rawImage;
}

@end
