#import "JSObjectionModule.h"
#import "JSObjectionBindingEntry.h"
#import "JSObjectionInjectorEntry.h"
#import <objc/runtime.h>
#import "JSObjectionProviderEntry.h"
#import "JSObjectionInjector.h"

@interface __JSClassProvider : NSObject<JSObjectionProvider> {
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


@interface JSObjectionModule() {
  NSMutableDictionary *_bindings;
  NSMutableSet *_eagerSingletons;
}

- (NSString *)classKey:(Class)class withName:(NSString*)name;
- (NSString *)protocolKey:(Protocol *)aProtocol withName:(NSString*)name;
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
    NSString *key = [self protocolKey:aProtocol withName:nil];
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:metaClass];
    [_bindings setObject:entry forKey:key];
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
    [self bind:instance toProtocol:aProtocol named:nil];
}

- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self ensureInstance: instance conformsTo: aProtocol];
    NSString *key = [self protocolKey:aProtocol withName:name];
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    [self bind:instance toClass:aClass named:nil];
}

- (void)bind:(id)instance toClass:(Class)aClass named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    JSObjectionBindingEntry *entry = [[JSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass {
    [self bindProvider:provider toClass:aClass named:nil];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toClass:(Class)aClass named:(NSString *)name {
    [self bindProvider:provider toClass:aClass inScope:JSObjectionScopeNormal named:name];
}

- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol {
    [self bindProvider:provider toProtocol:aProtocol named:nil];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self bindProvider:provider toProtocol:aProtocol inScope:JSObjectionScopeNormal named:name];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope {
    [self bindProvider:provider toClass:aClass inScope:scope named:nil];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope {
    [self bindProvider:provider toProtocol:aProtocol inScope:scope named:nil];
}

- (void)bindProvider:(id <JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self protocolKey:aProtocol withName:name];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol {
   [self bindClass:aClass toProtocol:aProtocol named:nil];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol named:(NSString*)name {
    [self bindClass:aClass toProtocol:aProtocol inScope:JSObjectionScopeNormal named:name];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope named:(NSString*)name{
    __JSClassProvider *provider = [[__JSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toProtocol:aProtocol inScope:scope named:name];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass {
    [self bindClass:aClass toClass:toClass named:nil];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass named:(NSString*)name {
    [self bindClass:aClass toClass:toClass inScope:JSObjectionScopeNormal named:name];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass inScope:(JSObjectionScope)scope named:(NSString*)name {
    __JSClassProvider *provider = [[__JSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toClass:toClass inScope:scope named:name];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass {
    [self bindBlock:block toClass:aClass named:nil];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass named:(NSString *)name {
    [self bindBlock:block toClass:aClass inScope:JSObjectionScopeNormal named:name];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol {
    [self bindBlock:block toProtocol:aProtocol named:nil];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self bindBlock:block toProtocol:aProtocol inScope:JSObjectionScopeNormal named:name];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *))block toClass:(Class)aClass inScope:(JSObjectionScope)scope {
    [self bindBlock:block toClass:aClass inScope:scope named:nil];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass inScope:(JSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithBlock:block lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *))block toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope {
    [self bindBlock:block toProtocol:aProtocol inScope:scope named:nil];
}

- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol
        inScope:(JSObjectionScope)scope named:(NSString *)name {
    NSString *key = [self protocolKey:aProtocol withName:name];
    JSObjectionProviderEntry *entry = [[JSObjectionProviderEntry alloc] initWithBlock:block lifeCycle: scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass inScope:(JSObjectionScope)scope {
    [_bindings setObject:[JSObjectionInjectorEntry entryWithClass:aClass scope:scope] forKey:[self classKey:aClass withName:nil]];
}

- (void) registerEagerSingleton:(Class)aClass  {
    [_eagerSingletons addObject:[self classKey:aClass withName:nil]];
}

- (BOOL)hasBindingForClass:(Class)aClass {
    return [self hasBindingForClass:aClass withName:nil];
}

- (BOOL)hasBindingForClass:(Class)aClass withName:(NSString*)name {
    return [_bindings objectForKey:[self classKey:aClass withName:name]] != nil;
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol {
   return [self hasBindingForProtocol:protocol withName:nil];
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol withName:(NSString*)name {
    return [_bindings objectForKey:[self protocolKey:protocol withName:name]] != nil;
}

- (void) configure {
}


#pragma mark - Private

- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol {
    if (![instance conformsToProtocol:aProtocol]) {
        @throw [NSException exceptionWithName:@"JSObjectionException"
                                       reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)]
                                     userInfo:nil];
    }
}

- (NSString *)classKey:(Class) aClass withName:(NSString*)name {
    return [NSString stringWithFormat:@"%@%@%@", NSStringFromClass(aClass), name ? @":" : @"", name ? name : @""];
}

- (NSString *)protocolKey:(Protocol *)aProtocol withName:(NSString*)name{
    return [NSString stringWithFormat:@"<%@>%@%@", NSStringFromProtocol(aProtocol), name ? @":" : @"", name ? name : @""];
}

@end
