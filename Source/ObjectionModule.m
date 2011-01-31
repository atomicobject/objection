#import "ObjectionModule.h"
#import "ObjectionInstanceEntry.h"

@implementation ObjectionModule
@synthesize bindings=_bindings;
@synthesize eagerSingletons=_eagerSingletons;

- (id)init {
  if (self = [super init]) {
    _bindings = [[NSMutableDictionary alloc] init];
    _eagerSingletons = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
  if (![instance conformsToProtocol:aProtocol]) {
    @throw [NSException exceptionWithName:@"ObjectionException" 
                        reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)] 
                        userInfo:nil];
  }
  
  NSString *key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(aProtocol)];
  ObjectionInstanceEntry *entry = [[[ObjectionInstanceEntry alloc] initWithObject:instance] autorelease];
  [_bindings setObject:entry forKey:key];  
}

- (void) bind:(id)instance toClass:(Class)aClass {
  NSString *key = NSStringFromClass(aClass);
  ObjectionInstanceEntry *entry = [[[ObjectionInstanceEntry alloc] initWithObject:instance] autorelease];
  [_bindings setObject:entry forKey:key];
}

- (void) registerEagerSingleton:(Class)klass {
  [_eagerSingletons addObject:NSStringFromClass(klass)];
}

- (void) configure {
}

- (void)dealloc {
  [_bindings release]; _bindings = nil;
  [_eagerSingletons release]; _eagerSingletons = nil;
  [super dealloc];
}
@end