#import "ObjectionModule.h"
#import "ObjectionInstanceEntry.h"

@implementation ObjectionModule
@synthesize bindings=_bindings;

- (id)init {
  if (self = [super init]) {
    _bindings = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void) bind:(id)instance toClass:(Class)aClass {
  NSString *key = NSStringFromClass(aClass);
  ObjectionInstanceEntry *entry = [[[ObjectionInstanceEntry alloc] initWithObject:instance] autorelease];
  [_bindings setObject:entry forKey:key];
}

- (void) configure {
}

- (void)dealloc {
  [_bindings release]; _bindings = nil;
  [super dealloc];
}
@end