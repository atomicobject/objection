#import "OCMockRecorder+PrimitiveReturnMethods.h"


@implementation OCMockRecorder (PrimitiveReturnMethods)

- (id)andReturnBool:(BOOL)value {
  NSValue *wrappedValue = nil;
  wrappedValue = [NSValue valueWithBytes:&value objCType:@encode(__typeof__(value))];
  return [self andReturnValue:wrappedValue];
}

- (id)andReturnInt:(int)value {
  NSValue *wrappedValue = nil;
  wrappedValue = [NSValue valueWithBytes:&value objCType:@encode(__typeof__(value))];
  return [self andReturnValue:wrappedValue];
}

- (id)andReturnFloat:(CGFloat)value {
  NSValue *wrappedValue = nil;
  wrappedValue = [NSValue valueWithBytes:&value objCType:@encode(__typeof__(value))];
  return [self andReturnValue:wrappedValue];
}

- (id)andReturnUnsignedInt:(NSUInteger)value {
  NSValue *wrappedValue = nil;
  wrappedValue = [NSValue valueWithBytes:&value objCType:@encode(__typeof__(value))];
  return [self andReturnValue:wrappedValue];  
}
@end
