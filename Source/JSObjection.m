#import "JSObjection.h"
#import <pthread.h>

static pthread_mutex_t gObjectionMutex;
static JSObjectionInjector *gGlobalInjector;

@implementation JSObjection

+ (JSObjectionInjector *)createInjector {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[[JSObjectionInjector alloc] init] autorelease];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex); 
    }

    return nil;
}

+ (void)initialize  {
    if (self == [JSObjection class]) {
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&gObjectionMutex, &mutexattr);
        pthread_mutexattr_destroy(&mutexattr);    
    }
}

+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector {
    if (gGlobalInjector != anInjector) {
        [gGlobalInjector release];
        gGlobalInjector = [anInjector retain];
    }
}

+ (JSObjectionInjector *) defaultInjector {  
    return [[gGlobalInjector retain] autorelease];
}

@end
