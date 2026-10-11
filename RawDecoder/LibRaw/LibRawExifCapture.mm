#import "LibRawExifCapture.h"

#import <libraw_datastream.h>

static const int kTiffTagMake = 0x010f;
static const int kTiffTagModel = 0x0110;
static const int kTiffTypeAscii = 2;
static const int kMaxTagLength = 256;

/// LibRaw encodes the IFD a tag came from in the upper bits: `tag | ((ifd + 1) << 20)` for
/// TIFF IFDs, `tag | 0x30000` for Panasonic, `tag | 0x20000` for Kodak. IFD0 is therefore
/// `(tag >> 20) == 1`
static bool tagIsFromIFD0(int tag) {
  return (tag >> 20) == 1;
}

/// TIFF ASCII values are NUL-terminated and often space-padded ("PENTAX             ")
static NSString * _Nullable stringFromTiffAscii(const char *bytes, int length) {
  while (length > 0 && (bytes[length - 1] == '\0' || bytes[length - 1] == ' ')) {
    length--;
  }
  if (length == 0) {
    return nil;
  }
  NSString *string = [[NSString alloc] initWithBytes:bytes length:(NSUInteger)length encoding:NSUTF8StringEncoding];
  if (string == nil) {
    string = [[NSString alloc] initWithBytes:bytes length:(NSUInteger)length encoding:NSISOLatin1StringEncoding];
  }
  return string;
}

@interface LibRawExifCapture () {
  bool _makeIsFromIFD0;
  bool _modelIsFromIFD0;
}
@property (readwrite, nullable) NSString *make;
@property (readwrite, nullable) NSString *model;
@end

@implementation LibRawExifCapture

static void exifParserCallback(void *context, int tag, int type, int length, unsigned int order, void *ifp, INT64 base) {
  LibRawExifCapture *capture = (__bridge LibRawExifCapture *)context;
  [capture handleTag:tag type:type length:length stream:ifp];
}

- (void)installOnLibrawData:(libraw_data_t *)librawData {
  libraw_set_exifparser_handler(librawData, exifParserCallback, (__bridge void *)self);
}

- (void)uninstallFromLibrawData:(libraw_data_t *)librawData {
  libraw_set_exifparser_handler(librawData, NULL, NULL);
}

- (void)handleTag:(int)tag type:(int)type length:(int)length stream:(void *)ifp {
  int baseTag = tag & 0xffff;
  if (baseTag != kTiffTagMake && baseTag != kTiffTagModel) {
    return;
  }
  if (type != kTiffTypeAscii || length <= 0 || length > kMaxTagLength) {
    return;
  }
  bool isMake = (baseTag == kTiffTagMake);
  bool fromIFD0 = tagIsFromIFD0(tag);
  // Keep the first value seen, unless this one is from IFD0 and the stored one is not
  if (isMake ? (self.make != nil && (_makeIsFromIFD0 || !fromIFD0))
             : (self.model != nil && (_modelIsFromIFD0 || !fromIFD0))) {
    return;
  }
  auto *stream = static_cast<LibRaw_abstract_datastream *>(ifp);
  INT64 position = stream->tell();
  char bytes[kMaxTagLength];
  int bytesRead = stream->read(bytes, 1, (size_t)length);
  stream->seek(position, SEEK_SET);
  if (bytesRead != length) {
    return;
  }
  NSString *value = stringFromTiffAscii(bytes, length);
  if (value == nil) {
    return;
  }
  if (isMake) {
    self.make = value;
    _makeIsFromIFD0 = fromIFD0;
  } else {
    self.model = value;
    _modelIsFromIFD0 = fromIFD0;
  }
}

@end
