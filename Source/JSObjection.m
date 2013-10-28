#import "JSObjection.h"
#import <pthread.h>
#import "JSObjectionInjectorEntry.h"
#import "JSObjectionRuntimePropertyReflector.h"

static NSMutableDictionary *gObjectionContext;
static pthread_mutex_t gObjectionMutex;
static JSObjectionInjector *gGlobalInjector;
static id<JSObjectionPropertyReflector> gPropertyReflector;

@implementation JSObjection

+ (JSObjectionInjector *)createInjector:(JSObjectionModule *)module {
        pthread_mutex_lock(&gObjectionMutex);
        @try {
            return [[JSObjectionInjector alloc] initWithContext:gObjectionContext andModule:module];
        }
        @finally {
            pthread_mutex_unlock(&gObjectionMutex); 
        }

        return nil;
}

+ (JSObjectionInjector *)createInjectorWithModulesArray:(NSArray *)modules {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[JSObjectionInjector alloc] initWithContext:gObjectionContext andModules:modules];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex);
    }
    
    return nil;
}

+ (JSObjectionInjector *)createInjectorWithModules:(JSObjectionModule *)first, ... {
    va_list va_modules;
    NSMutableArray *modules = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);

    JSObjectionModule *module;
    while ((module = va_arg( va_modules, JSObjectionModule *) )) {
        [modules addObject:module];
    }

    va_end(va_modules);
    return [self createInjectorWithModulesArray:modules];
}

+ (JSObjectionInjector *)createInjector {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[JSObjectionInjector alloc] initWithContext:gObjectionContext];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex); 
    }

    return nil;
}

+ (void)initialize  {
    if (self == [JSObjection class]) {
        gObjectionContext = [[NSMutableDictionary alloc] init];
        gPropertyReflector = [[JSObjectionRuntimePropertyReflector alloc] init];
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&gObjectionMutex, &mutexattr);
        pthread_mutexattr_destroy(&mutexattr);    
    }
}

+ (void) registerClass:(Class)theClass scope:(JSObjectionScope)scope {
    pthread_mutex_lock(&gObjectionMutex);
    if (scope != JSObjectionScopeSingleton && scope != JSObjectionScopeNormal) {
        @throw [NSException exceptionWithName:@"JSObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
    }

    if (theClass && [gObjectionContext objectForKey:NSStringFromClass(theClass)] == nil) {
        [gObjectionContext setObject:[JSObjectionInjectorEntry entryWithClass:theClass scope:scope] forKey:NSStringFromClass(theClass)];
    } 
    pthread_mutex_unlock(&gObjectionMutex);
}

+ (void) reset {
    pthread_mutex_lock(&gObjectionMutex);
    [gObjectionContext removeAllObjects];
    pthread_mutex_unlock(&gObjectionMutex);
}

+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector {
    if (gGlobalInjector != anInjector) {
        gGlobalInjector = anInjector;
    }
}

+ (JSObjectionInjector *) defaultInjector {  
    return gGlobalInjector;
}

+ (JSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName {
    return [gPropertyReflector propertyForClass:theClass andProperty: propertyName];
}

+ (void)setPropertyReflector:(id<JSObjectionPropertyReflector>)reflector {
    if(gPropertyReflector != reflector) {
        gPropertyReflector = reflector;
    }
}
@end
