#import <RawSpeed-API.h>

#import "RDCFA.h"
#import "RDCFAColor.h"

@interface RDCFA ()
@property (readonly, direct) RDCFAColor *cfaColors;
@end

@implementation RDCFA

- (instancetype) initWithCFAColors:(RDCFAColor *)cfaColors
                             width:(NSInteger)width
                            height:(NSInteger)height {
  self = [super init];
  if (self) {
    _width = width;
    _height = height;
    _cfaColors = (RDCFAColor *)malloc(sizeof(RDCFAColor) * (NSUInteger)_width * (NSUInteger)_height);
    NSMutableArray<NSNumber*> *exifCFAPattern = [NSMutableArray new];
    for (int y = 0; y < _height; y++) {
      for (int x = 0; x < _width; x++) {
        RDCFAColor color = cfaColors[x + y * _width];
        [exifCFAPattern addObject:[NSNumber numberWithInt:(int)color]];
        _cfaColors[x + y * _width] = RDCFAColor(color);
      }
    }
    _exifCFAPattern = [NSArray arrayWithArray:exifCFAPattern];
  }
  return self;
}

- (instancetype) initWithCFA:(rawspeed::ColorFilterArray)cfa {
  self = [super init];
  if (self) {
    _height = cfa.getSize().y;
    _width = cfa.getSize().x;
    _cfaColors = (RDCFAColor *)malloc(sizeof(RDCFAColor) * (NSUInteger)_width * (NSUInteger)_height);
    NSMutableArray<NSNumber*> *exifCFAPattern = [NSMutableArray new];
    for (int y = 0; y < _height; y++) {
      for (int x = 0; x < _width; x++) {
        rawspeed::CFAColor color = cfa.getColorAt(x, y);
        [exifCFAPattern addObject:[NSNumber numberWithInt:(int)color]];
        _cfaColors[x + y * _width] = RDCFAColor(color);
      }
    }
    _exifCFAPattern = [NSArray arrayWithArray:exifCFAPattern];
  }
  return self;
}

- (void)dealloc {
  free(_cfaColors);
}

- (RDCFAColor)colorAtX:(NSInteger)x
                     y:(NSInteger)y {
  return _cfaColors[x + y * _width];
}
@end
