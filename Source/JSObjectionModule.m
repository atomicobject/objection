#import "JSObjectionModule.h"
#import "JSObjectionBindingEntry.h"
#import "JSObjectionInjectorEntry.h"
#import <objc/runtime.h>
#import <Objection/JSObjectionProviderEntry.h>
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

- (id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments {
    return [context getObject:_class argumentList:arguments];
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
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:metaClass];
    [_bindings setObject:entry forKey:key];    
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
    [self ensureInstance: instance conformsTo: aProtocol];
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];  
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass {
    [self bindProvider:provider toClass:aClass inScope:JSObjectionScopeNormal];
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol {
    [self bindProvider:provider toProtocol:aProtocol inScope:JSObjectionScopeNormal];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope {
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol {

    __JSClassProvider *provider = [[__JSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toProtocol:aProtocol];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass {
    __JSClassProvider *provider = [[__JSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toClass:toClass];
}


- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass {
    [self bindBlock:block toClass:aClass inScope:JSObjectionScopeNormal];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol {
    [self bindBlock:block toProtocol:aProtocol inScope:JSObjectionScopeNormal];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *))block toClass:(Class)aClass inScope:(JSObjectionScope)scope {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithBlock:block lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *))block toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope {
    NSString *key = [self protocolKey:aProtocol];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithBlock:block lifeCycle: scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass inScope:(JSObjectionScope)scope {
    [_bindings setObject:[JSObjectionInjectorEntry entryWithClass:aClass scope:scope] forKey:NSStringFromClass(aClass)];
}

- (void) registerEagerSingleton:(Class)aClass  {
    [_eagerSingletons addObject:NSStringFromClass(aClass)];
}

- (BOOL)hasBindingForClass:(Class)aClass {
  return [_bindings objectForKey:NSStringFromClass(aClass)] != nil;
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol {
  return [_bindings objectForKey:[self protocolKey:protocol]] != nil;
}

- (void) configure {
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