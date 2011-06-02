#import "Objection.h"
#import <pthread.h>

static NSMutableDictionary *gObjectionContext;
static pthread_mutex_t gObjectionMutex;
static ObjectionInjector *gGlobalInjector;

@implementation Objection

+ (ObjectionInjector *) createInjector:(ObjectionModule *)aModule 
{
  pthread_mutex_lock(&gObjectionMutex);
  @try {
    return [[[ObjectionInjector alloc] initWithContext:gObjectionContext andModule:aModule] autorelease];
  }
  @finally {
    pthread_mutex_unlock(&gObjectionMutex); 
  }
}

+ (ObjectionInjector *) createInjector 
{
  pthread_mutex_lock(&gObjectionMutex);
  @try {
    return [[[ObjectionInjector alloc] initWithContext:gObjectionContext] autorelease];
  }
  @finally {
    pthread_mutex_unlock(&gObjectionMutex); 
  }
}

+ (void)initialize 
{
  if (self == [Objection class]) {
		gObjectionContext = [[NSMutableDictionary alloc] init];
    pthread_mutexattr_t mutexattr;
    pthread_mutexattr_init(&mutexattr);
    pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&gObjectionMutex, &mutexattr);
    pthread_mutexattr_destroy(&mutexattr);    
  }
}

+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle 
{
  pthread_mutex_lock(&gObjectionMutex);
  if (lifeCycle != ObjectionInstantiationRuleSingleton && lifeCycle != ObjectionInstantiationRuleNormal) {
    @throw [NSException exceptionWithName:@"ObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
  }
  
  if (theClass && [gObjectionContext objectForKey:NSStringFromClass(theClass)] == nil) {
    [gObjectionContext setObject:[ObjectionInjectorEntry entryWithClass:theClass lifeCycle:lifeCycle] forKey:NSStringFromClass(theClass)];
  } 
  pthread_mutex_unlock(&gObjectionMutex);
}

+ (void) reset 
{
  pthread_mutex_lock(&gObjectionMutex);
  [gObjectionContext removeAllObjects];
  pthread_mutex_unlock(&gObjectionMutex);
}

+ (void)setGlobalInjector:(ObjectionInjector *)anInjector 
{
  if (gGlobalInjector != anInjector) {
    [gGlobalInjector release];
    gGlobalInjector = [anInjector retain];
  }
}

+ (ObjectionInjector *) globalInjector 
{  
  return [[gGlobalInjector retain] autorelease];
}
@end
