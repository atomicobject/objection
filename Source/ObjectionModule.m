#import "ObjectionModule.h"
#import "ObjectionBindingEntry.h"
#import "ObjectionProviderEntry.h"
#import <objc/runtime.h>

@interface ObjectionModule()
- (NSString *)protocolKey:(Protocol *)aProtocol;
- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol;
@end

@implementation ObjectionModule
@synthesize bindings = _bindings;
@synthesize eagerSingletons = _eagerSingletons;

- (id)init 
{
  if ((self = [super init])) {
    _bindings = [[NSMutableDictionary alloc] init];
    _eagerSingletons = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol 
{
  if (!class_isMetaClass(object_getClass(metaClass))) {
    @throw [NSException exceptionWithName:@"ObjectionException" 
                          reason:[NSString stringWithFormat:@"\"%@\" can not be bound to the protocol \"%@\" because it is not a meta class", metaClass, NSStringFromProtocol(aProtocol)]
                          userInfo:nil];
  }
  NSString *key = [self protocolKey:aProtocol];
  ObjectionBindingEntry *entry = [[[ObjectionBindingEntry alloc] initWithObject:metaClass] autorelease];
  [_bindings setObject:entry forKey:key];    
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol 
{
  [self ensureInstance: instance conformsTo: aProtocol];
  NSString *key = [self protocolKey:aProtocol];
  ObjectionBindingEntry *entry = [[[ObjectionBindingEntry alloc] initWithObject:instance] autorelease];
  [_bindings setObject:entry forKey:key];  
}

- (void) bind:(id)instance toClass:(Class)aClass 
{
  NSString *key = NSStringFromClass(aClass);
  ObjectionBindingEntry *entry = [[[ObjectionBindingEntry alloc] initWithObject:instance] autorelease];
  [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<ObjectionProvider>)provider toClass:(Class)aClass
{
  NSString *key = NSStringFromClass(aClass);
  ObjectionProviderEntry *entry = [[[ObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
  [_bindings setObject:entry forKey:key];  
}

- (void)bindProvider:(id<ObjectionProvider>)provider toProtocol:(Protocol *)aProtocol
{
  NSString *key = [self protocolKey:aProtocol];
  ObjectionProviderEntry *entry = [[[ObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
  [_bindings setObject:entry forKey:key];  
}

#if NS_BLOCKS_AVAILABLE
- (void)bindBlock:(id (^)(ObjectionInjector *context))block toClass:(Class)aClass
{
  NSString *key = NSStringFromClass(aClass);
  ObjectionProviderEntry *entry = [[[ObjectionProviderEntry alloc] initWithBlock:block] autorelease];
  [_bindings setObject:entry forKey:key];    
}

- (void)bindBlock:(id (^)(ObjectionInjector *context))block toProtocol:(Protocol *)aProtocol
{
  NSString *key = [self protocolKey:aProtocol];
  ObjectionProviderEntry *entry = [[[ObjectionProviderEntry alloc] initWithBlock:block] autorelease];
  [_bindings setObject:entry forKey:key];    
}
#endif

- (void) registerEagerSingleton:(Class)klass 
{
  [_eagerSingletons addObject:NSStringFromClass(klass)];
}

- (void) configure 
{
}

- (void)dealloc 
{
  [_bindings release]; _bindings = nil;
  [_eagerSingletons release]; _eagerSingletons = nil;
  [super dealloc];
}

#pragma mark Private
#pragma mark -

- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol  
{
  if (![instance conformsToProtocol:aProtocol]) {
    @throw [NSException exceptionWithName:@"ObjectionException" 
                                   reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)] 
                                 userInfo:nil];
  }
  
}

- (NSString *)protocolKey:(Protocol *)aProtocol 
{
 return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(aProtocol)]; 
}

@end