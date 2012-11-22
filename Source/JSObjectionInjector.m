#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectFactory.h"
#import "JSObjectionUtils.h"
#import "Objection.h"

#import <pthread.h>
#import <objc/runtime.h>

@interface __JSObjectionInjectorDefaultModule : JSObjectionModule
{
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

- (void)configure   {
    [self bind:[[[JSObjectFactory alloc] initWithInjector:_injector] autorelease] toClass:[JSObjectFactory class]];
}

- (void)dealloc {
    [_injector release];
    [super dealloc];
}
@end
  
@interface JSObjectionInjector(Private)
- (void)initializeEagerSingletons;
- (void)configureDefaultModule;
- (void)configureModule:(JSObjectionModule *)module;
@end

@interface JSObjectionInjector ()
@property(nonatomic, readonly) NSMutableDictionary *modules;

@end

@implementation JSObjectionInjector
@synthesize modules = _modules;


- (id)initWithContext:(NSDictionary *)theGlobalContext {
    if ((self = [super init])) {
        _globalContext = [theGlobalContext retain];
        _context = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
        [self configureDefaultModule];
    }

    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule {
    if ((self = [self initWithContext:theGlobalContext])) {
        [self addModule:theModule];
    }
    return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)modules {
    if ((self = [self initWithContext:theGlobalContext])) {
        [self addModules:modules];
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

- (id)objectForKeyedSubscript: (id)key {
    return [self getObjectWithArgs:key, nil];
}


- (id)getObject:(id)classOrProtocol {
    return [self getObjectWithArgs:classOrProtocol, nil];
}

- (id)getObject:(id)classOrProtocol arguments:(va_list)argList {
    @synchronized(self) {    
        if (!classOrProtocol) {
            return nil;
        }
        
        NSString *key = nil;
        if (class_isMetaClass(object_getClass(classOrProtocol))) {
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
        id entry = [_globalContext objectForKey:eagerSingletonKey];
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
    NSSet *mergedSet = [module.eagerSingletons setByAddingObjectsFromSet:_eagerSingletons];
    [_eagerSingletons release];
    _eagerSingletons = [mergedSet mutableCopy];
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


#pragma mark edit sschmid

- (void)addModule:(JSObjectionModule *)module {
    [self configureModule:module];
    [self.modules setObject:module forKey:NSStringFromClass([module class])];
    [self initializeEagerSingletons];
}

- (void)addModules:(NSArray *)modules {
    for (JSObjectionModule *module in modules) {
        [self configureModule:module];
        [self.modules setObject:module forKey:NSStringFromClass([module class])];
    }
    [self initializeEagerSingletons];
}

- (void)removeModule:(Class)moduleClass {
    NSString *key = NSStringFromClass(moduleClass);
    JSObjectionModule *module = [self.modules objectForKey:key];
    if (module) {
        for (NSString *bindingKey in module.bindings) {
            [_context removeObjectForKey:bindingKey];
        }
        for (NSString *eagerSingletonKey in module.eagerSingletons) {
            [_eagerSingletons removeObject:eagerSingletonKey];
            [_context removeObjectForKey:eagerSingletonKey];
            [JSObjection unRegisterClassName:eagerSingletonKey];
        }
        [self.modules removeObjectForKey:key];
    }
}

- (BOOL)hasModule:(Class)moduleClass {
    return [self.modules objectForKey:NSStringFromClass(moduleClass)] != nil;
}


@end
