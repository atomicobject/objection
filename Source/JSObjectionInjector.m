#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectFactory.h"
#import "JSObjectionUtils.h"
#import "JSObjectionInjectorEntry.h"

#import <pthread.h>
#import <objc/runtime.h>

@interface __JSObjectionInjectorDefaultModule : JSObjectionModule
@property (nonatomic, weak) JSObjectionInjector *injector;
@end

@implementation __JSObjectionInjectorDefaultModule

- (id)initWithInjector:(JSObjectionInjector *)injector {
    if ((self = [super init])) {
        self.injector = injector;
    }
    return self;
}

- (void)configure   {
    [self bind:[[JSObjectFactory alloc] initWithInjector:self.injector] toClass:[JSObjectFactory class]];
}

@end
  
@interface JSObjectionInjector(Private)
- (void)initializeEagerSingletons;
- (void)configureDefaultModule;
- (void)configureModule:(JSObjectionModule *)module;
@end

@implementation JSObjectionInjector

- (id)initWithContext:(NSDictionary *)theGlobalContext {
    if ((self = [super init])) {
        _globalContext = theGlobalContext;
        _context = [[NSMutableDictionary alloc] init];
        _modules = [[NSMutableArray alloc] init];
        [self configureDefaultModule];
        [self initializeEagerSingletons];
    }

    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule {
    if ((self = [self initWithContext:theGlobalContext])) {
        [self configureModule:theModule];
        [self initializeEagerSingletons];
    }
    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)theModules {
    if ((self = [self initWithContext:theGlobalContext])) {
        for (JSObjectionModule *module in theModules) {
            [self configureModule:module];      
        }
        [self initializeEagerSingletons];
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

- (id)getObject:(id)classOrProtocol {
    return [self getObjectWithArgs:classOrProtocol, nil];
}

- (id)getObject:(id)classOrProtocol argumentList:(NSArray *)argumentList {
    @synchronized(self) {
        if (!classOrProtocol) {
            return nil;
        }
        NSString *key = nil;
        BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
        
        if (isClass) {
            key = NSStringFromClass(classOrProtocol);
        } else {
            key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
        }
        
        
        id<JSObjectionEntry> injectorEntry = [_context objectForKey:key];
        injectorEntry.injector = self;
        
        if (!injectorEntry) {
            id<JSObjectionEntry> entry = [_globalContext objectForKey:key];
            if (entry) {
                injectorEntry = [[entry class] entryWithEntry:entry];
                injectorEntry.injector = self;
                [_context setObject:injectorEntry forKey:key];
            } else if(isClass) {
                injectorEntry = [JSObjectionInjectorEntry entryWithClass:classOrProtocol scope:JSObjectionScopeNormal];
                injectorEntry.injector = self;
                [_context setObject:injectorEntry forKey:key];
            }
        }
        
        if (classOrProtocol && injectorEntry) {
            return [injectorEntry extractObject:argumentList];
        }
        
        return nil;
    }
    
    return nil;
    
}

- (id)getObject:(id)classOrProtocol arguments:(va_list)argList {
    NSArray *arguments = JSObjectionUtils.transformVariadicArgsToArray(argList);
    return [self getObject:classOrProtocol argumentList:arguments];
}

- (id)objectForKeyedSubscript: (id)key {
    return [self getObjectWithArgs:key, nil];
}


- (id)withModule:(JSObjectionModule *)theModule {
    return [self withModuleCollection:[NSArray arrayWithObject:theModule]];    
}

- (id)withModules:(JSObjectionModule *)first, ... {
    va_list va_modules;
    NSMutableArray *modules = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);
    
    JSObjectionModule *module;
    while ((module = va_arg( va_modules, JSObjectionModule *) )) {
        [modules addObject:module];
    }
    
    va_end(va_modules);
    return [self withModuleCollection:modules];
   
}

- (id)withModuleCollection:(NSArray *)theModules {
    NSMutableArray *mergedModules = [NSMutableArray arrayWithArray:_modules];
    [mergedModules addObjectsFromArray:theModules];
    return [[[self class] alloc] initWithContext:_globalContext andModules:mergedModules];
}

- (id)withoutModuleOfType:(Class)moduleClass {
    return [self withoutModuleCollection:[NSArray arrayWithObject:moduleClass]];
}

- (id)withoutModuleOfTypes:(Class)first, ... {
    va_list va_modules;
    NSMutableArray *classes = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);
    
    Class aClass;
    while ((aClass = va_arg( va_modules, Class) )) {
        [classes addObject:aClass];
    }
    
    va_end(va_modules);
    return [self withoutModuleCollection:classes];

}

- (id)withoutModuleCollection:(NSArray *)moduleClasses {
    NSMutableArray *remainingModules = [NSMutableArray arrayWithArray:_modules];
    NSMutableArray *withDefaultModule = [NSMutableArray arrayWithArray:moduleClasses];
    [withDefaultModule addObject:[__JSObjectionInjectorDefaultModule class]];
    for (JSObjectionModule *module in _modules) {
        for (Class moduleClass in withDefaultModule) {
            if([module isKindOfClass:moduleClass]) {
                [remainingModules removeObject:module];
            }
        }
    }
    return [[[self class] alloc] initWithContext:_globalContext andModules:remainingModules];
}


- (void)injectDependencies:(id)object {
    JSObjectionUtils.injectDependenciesIntoProperties(self, [object class], object);
}

#pragma mark - Private

- (void)initializeEagerSingletons {
    for (NSString *eagerSingletonKey in _eagerSingletons) {
        id entry = [_context objectForKey:eagerSingletonKey] ?: [_globalContext objectForKey:eagerSingletonKey];
        if ([entry lifeCycle] == JSObjectionScopeSingleton) {
            [self getObject:NSClassFromString(eagerSingletonKey)];      
        } else {
            @throw [NSException exceptionWithName:@"JSObjectionException" 
                                           reason:[NSString stringWithFormat:@"Unable to initialize eager singleton for the class '%@' because it was never registered as a singleton", eagerSingletonKey] 
                                         userInfo:nil];
        }
    }
}

- (void)configureModule:(JSObjectionModule *)module {
    [_modules addObject:module];
    [module configure];
    NSSet *mergedSet = [module.eagerSingletons setByAddingObjectsFromSet:_eagerSingletons];
    _eagerSingletons = mergedSet;
    [_context addEntriesFromDictionary:module.bindings];
}

- (void)configureDefaultModule {
    __JSObjectionInjectorDefaultModule *module = [[__JSObjectionInjectorDefaultModule alloc] initWithInjector:self];
    [self configureModule:module];
}

#pragma mark - 


@end
