#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectFactory.h"
#import "JSObjectionUtils.h"
#import "Objection.h"

@interface __JSObjectionInjectorDefaultModule : JSObjectionModule {
    JSObjectionInjector *_injector;
}
@end

@implementation __JSObjectionInjectorDefaultModule

- (id)initWithInjector:(JSObjectionInjector *)injector {
    if ((self = [super init])) {
        _injector = [injector retain];
    }
    return self;
}

- (void)configure:(JSObjectionInjector *)injector {
    [self bind:[[[JSObjectFactory alloc] initWithInjector:_injector] autorelease] toClass:[JSObjectFactory class]];
}

- (void)dealloc {
    [_injector release];
    [super dealloc];
}
@end

@interface JSObjectionInjector (Private)
- (void)initializeEagerSingletons;

- (void)configureDefaultModule;

- (void)configureModule:(JSObjectionModule *)module;
@end

@implementation JSObjectionInjector

- (id)init {
    if ((self = [super init])) {
        _context = [[NSMutableDictionary alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
        [self configureDefaultModule];
    }

    return self;
}

- (id)getObjectWithArgs:(id)classOrProtocol, ... {
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    id object = [self getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

- (id)objectForKeyedSubscript:(id)key {
    return [self getObjectWithArgs:key, nil];
}

- (id)getObject:(id)classOrProtocol {
    return [self getObjectWithArgs:classOrProtocol, nil];
}

- (id)getObject:(id)classOrProtocol arguments:(va_list)argList {
    @synchronized (self) {
        if (!classOrProtocol)
            return nil;

        NSString *key = nil;
        if (class_isMetaClass(object_getClass(classOrProtocol)))
            key = NSStringFromClass(classOrProtocol);
        else
            key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];

        id <JSObjectionEntry> injectorEntry = [_context objectForKey:key];
        injectorEntry.injector = self;

        if (classOrProtocol && injectorEntry) {
            NSArray *arguments = JSObjectionUtils.transformVariadicArgsToArray(argList);
            return [injectorEntry extractObject:arguments];
        }

        return nil;
    }

    return nil;

}


#pragma mark - Private

- (void)initializeEagerSingletons {
    for (NSString *eagerSingletonKey in _eagerSingletons) {
        id entry = [_context objectForKey:eagerSingletonKey];
        if ([entry lifeCycle] == JSObjectionInstantiationRuleSingleton) {
            [self getObject:NSClassFromString(eagerSingletonKey)];
        } else {
            @throw [NSException exceptionWithName:@"JSObjectionException"
                                           reason:[NSString stringWithFormat:@"Unable to initialize eager singleton for the class '%@' because it was never registered as a singleton", eagerSingletonKey]
                                         userInfo:nil];
        }
    }
}

- (void)configureModule:(JSObjectionModule *)module {
    [module configure:self];
    for (NSString *singleton in module.eagerSingletons)
        [_eagerSingletons addObject:singleton];
    [_context addEntriesFromDictionary:module.bindings];
}

- (void)configureDefaultModule {
    __JSObjectionInjectorDefaultModule *module = [[[__JSObjectionInjectorDefaultModule alloc] initWithInjector:self] autorelease];
    [self addModule:module];
}

#pragma mark - 

- (void)dealloc {
    [_context release];
    [_eagerSingletons release];
    [_modules release];
    [super dealloc];
}

- (void)addModule:(JSObjectionModule *)module {
    [self addModule:module withName:NSStringFromClass([module class])];
}

- (void)addModules:(NSArray *)modules {
    for (JSObjectionModule *module in modules) {
        [self registerModule:module name:NSStringFromClass([module class])];
        [self configureModule:module];
    }
    [self initializeEagerSingletons];
}

- (void)addModule:(JSObjectionModule *)module withName:(NSString *)name {
    [self registerModule:module name:name];
    [self configureModule:module];
    [self initializeEagerSingletons];
}

- (void)registerModule:(JSObjectionModule *)module name:(NSString *)name {
    if (![_modules objectForKey:name])
        [_modules setObject:module forKey:name];
}

- (void)removeModuleClass:(Class)aClass {
    [self removeModuleWithName:NSStringFromClass(aClass)];
}

- (void)removeModuleWithName:(NSString *)name {
    JSObjectionModule *module = [_modules objectForKey:name];
    if (module) {
        [self unConfigureModule:module];
        [module unload];
        [_modules removeObjectForKey:name];
    }
}

- (void)removeAllModules {
    for (NSString *moduleKey in [_modules allKeys])
        [self removeModuleWithName:moduleKey];
}

- (BOOL)hasModuleClass:(Class)aClass {
    return [self hasModuleWithName:NSStringFromClass(aClass)];
}

- (BOOL)hasModuleWithName:(NSString *)name {
    return [_modules objectForKey:name] != nil;
}

- (void)unConfigureModule:(JSObjectionModule *)module {
    for (NSString *bindingKey in module.bindings) {
        [self removeAutoRegisteredModules:[_context objectForKey:bindingKey]];
        [_context removeObjectForKey:bindingKey];
    }

    for (NSString *singleton in module.eagerSingletons)
        [_eagerSingletons removeObject:singleton];
}

- (void)removeAutoRegisteredModules:(id)entry {
    if ([entry isKindOfClass:[JSObjectionInjectorEntry class]])
        for (JSObjectionModule *module in ((JSObjectionInjectorEntry *) entry).autoRegisteredModules)
            [self unConfigureModule:module];
}

- (void)dumpContext {
    NSLog(@"JSObjectionInjector context:::");
    JSObjectionModule *module;
    for (NSString *moduleKey in _modules) {
        module = [_modules objectForKey:moduleKey];
        for (NSString *bindingKey in module.bindings) {
            NSLog(@"- %@ : %@", bindingKey, [module.bindings objectForKey:bindingKey]);
        }
    }
    NSLog(@"JSObjection end:::");
}

@end
