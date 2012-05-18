#import "JSObjectionModule.h"
#import "JSObjectionBindingEntry.h"
#import "JSObjectionProviderEntry.h"
#import <objc/runtime.h>
#import "JSObjectionInjector.h"

@interface __JSClassProvider : NSObject<JSObjectionProvider>
{
    Class _class;
}
- (id)initWithClass:(Class)aClass;
@end

@implementation __JSClassProvider

- (id)initWithClass:(Class)aClass {
    if ((self = [super init])) {
        _class = aClass;
    }
    return self;
}

- (id)provide:(JSObjectionInjector *)context {
    return [context getObject:_class];
}

@end

@interface JSObjectionModule()
- (NSString *)protocolKey:(Protocol *)aProtocol;
- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol;
@end

@implementation JSObjectionModule
@synthesize bindings = _bindings;
@synthesize eagerSingletons = _eagerSingletons;

- (id)init {
    if ((self = [super init])) {
        _bindings = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol {
    if (!class_isMetaClass(object_getClass(metaClass))) {
        @throw [NSException exceptionWithName:@"JSObjectionException" 
                                       reason:[NSString stringWithFormat:@"\"%@\" can not be bound to the protocol \"%@\" because it is not a meta class", metaClass, NSStringFromProtocol(aProtocol)]
                                     userInfo:nil];
    }    
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionBindingEntry *entry = [[[JSObjectionBindingEntry alloc] initWithObject:metaClass] autorelease];
    [_bindings setObject:entry forKey:key];    
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
    [self ensureInstance: instance conformsTo: aProtocol];
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionBindingEntry *entry = [[[JSObjectionBindingEntry alloc] initWithObject:instance] autorelease];
    [_bindings setObject:entry forKey:key];  
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionBindingEntry *entry = [[[JSObjectionBindingEntry alloc] initWithObject:instance] autorelease];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
    [_bindings setObject:entry forKey:key];  
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol {
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
    [_bindings setObject:entry forKey:key];  
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol {
    NSString *key = [self protocolKey:aProtocol];
    __JSClassProvider *provider = [[[__JSClassProvider alloc] initWithClass:aClass] autorelease];
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
    [_bindings setObject:entry forKey:key];  
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass {
    NSString *key = NSStringFromClass(toClass);
    __JSClassProvider *provider = [[[__JSClassProvider alloc] initWithClass:aClass] autorelease];
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithProvider:provider] autorelease];
    [_bindings setObject:entry forKey:key];    
}


- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithBlock:block] autorelease];
    [_bindings setObject:entry forKey:key];    
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol {
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionProviderEntry *entry = [[[JSObjectionProviderEntry alloc] initWithBlock:block] autorelease];
    [_bindings setObject:entry forKey:key];    
}

- (void) registerEagerSingleton:(Class)klass  {
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

- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol {
      if (![instance conformsToProtocol:aProtocol]) {
            @throw [NSException exceptionWithName:@"JSObjectionException" 
                                           reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)] 
                                         userInfo:nil];
      }  
}

- (NSString *)protocolKey:(Protocol *)aProtocol {
    return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(aProtocol)]; 
}

@end