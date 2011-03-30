#import "ObjectionModule.h"
#import "ObjectionInstanceEntry.h"
#import <objc/runtime.h>

@interface ObjectionModule()
- (NSString *)protocolKey:(Protocol *)aProtocol;
@end

@implementation ObjectionModule
@synthesize bindings = _bindings;
@synthesize eagerSingletons = _eagerSingletons;

- (id)init {
  if (self = [super init]) {
    _bindings = [[NSMutableDictionary alloc] init];
    _eagerSingletons = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol {
  if (!class_isMetaClass(object_getClass(metaClass))) {
    @throw [NSException exceptionWithName:@"ObjectionException" 
                          reason:[NSString stringWithFormat:@"\"%@\" can not be bound to the protocol \"%@\" because it is not a meta class", metaClass, NSStringFromProtocol(aProtocol)]
                          userInfo:nil];
  }
  NSString *key = [self protocolKey:aProtocol];
  ObjectionInstanceEntry *entry = [[[ObjectionInstanceEntry alloc] initWithObject:metaClass] autorelease];
  [_bindings setObject:entry forKey:key];    
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
  if (![instance conformsToProtocol:aProtocol]) {
    @throw [NSException exceptionWithName:@"ObjectionException" 
                        reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)] 
                        userInfo:nil];
  }
  
  NSString *key = [self protocolKey:aProtocol];
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

#pragma mark Private
#pragma mark -

- (NSString *)protocolKey:(Protocol *)aProtocol {
 return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(aProtocol)]; 
}

@end