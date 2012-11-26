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

- (void)configure {
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

- (id)initWithContext:(NSDictionary *)theGlobalContext {
    if ((self = [super init])) {
        _globalContext = [theGlobalContext retain];
        _context = [[NSMutableDictionary alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
        [self configureDefaultModule];
    }

    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule {
    if ((self = [self initWithContext:theGlobalContext]))
        [self addModule:theModule];
    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)modules {
    if ((self = [self initWithContext:theGlobalContext]))
        [self addModules:modules];
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
        if (!classOrProtocol) {
            return nil;
        }

        NSString *key = nil;
        if (class_isMetaClass(object_getClass(classOrProtocol))) {
            key = NSStringFromClass(classOrProtocol);
        } else {
            key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
        }


        id <JSObjectionEntry> injectorEntry = [_context objectForKey:key];
        injectorEntry.injector = self;

        if (!injectorEntry) {
            id <JSObjectionEntry> entry = [_globalContext objectForKey:key];
            if (entry) {
                injectorEntry = [[entry class] entryWithEntry:entry];
                injectorEntry.injector = self;
                [_context setObject:injectorEntry forKey:key];
            }
        }

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
        if (!entry)
            entry = [_globalContext objectForKey:eagerSingletonKey];
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
    [module configure];
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
    [_globalContext release];
    [_context release];
    [_eagerSingletons release];
    [_modules release];
    [super dealloc];
}

- (void)addModule:(JSObjectionModule *)module {
    [self registerModule:module];
    [self configureModule:module];
    [self initializeEagerSingletons];
}

- (void)addModules:(NSArray *)modules {
    for (JSObjectionModule *module in modules) {
        [self registerModule:module];
        [self configureModule:module];
    }
    [self initializeEagerSingletons];
}

- (void)registerModule:(JSObjectionModule *)module {
    NSString *key = NSStringFromClass([module class]);
    if (![_modules objectForKey:key])
        [_modules setObject:module forKey:key];
}

- (void)removeModule:(Class)aClass {
    NSString *key = NSStringFromClass(aClass);
    JSObjectionModule *module = [_modules objectForKey:key];
    if (module) {
        [self unConfigureModule:module];
        [_modules removeObjectForKey:key];
    }
}

- (void)removeAllModules {
    for (NSString *moduleKey in [_modules allKeys])
        [self removeModule:NSClassFromString(moduleKey)];
}

- (BOOL)hasModule:(Class)aClass {
    return [_modules objectForKey:NSStringFromClass(aClass)] != nil;
}

- (void)unConfigureModule:(JSObjectionModule *)module {
    for (NSString *bindingKey in module.bindings) {
        [self unRegisterAutoRegisteredClasses:[_context objectForKey:bindingKey]];
        [_context removeObjectForKey:bindingKey];
    }

    for (NSString *singleton in module.eagerSingletons)
        [_eagerSingletons removeObject:singleton];
}

- (void)unRegisterAutoRegisteredClasses:(id)entry {
    if ([entry isKindOfClass:[JSObjectionInjectorEntry class]])
        for (id aClass in ((JSObjectionInjectorEntry *) entry).autoRegisteredClasses)
            [JSObjection unRegisterClass:aClass];
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
