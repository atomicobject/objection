#import <OCMock/OCMock.h>

@interface OCMockRecorder (PrimitiveReturnMethods) 

- (id)andReturnBool:(BOOL)value;
- (id)andReturnInt:(int)value;
- (id)andReturnFloat:(CGFloat)value;
- (id)andReturnUnsignedInt:(NSUInteger)value;
@end
