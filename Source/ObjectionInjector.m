#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"
#import <pthread.h>

static NSMutableDictionary *gObjectionContext;
static pthread_mutex_t gObjectionMutex;

@implementation ObjectionInjector

+ (void)initialize {
  if (self == [ObjectionInjector class]) {
		gObjectionContext = [[NSMutableDictionary alloc] init];
    pthread_mutexattr_t mutexattr;
    pthread_mutexattr_init(&mutexattr);
    pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&gObjectionMutex, &mutexattr);
    pthread_mutexattr_destroy(&mutexattr);    
  }
}

+ (void) registerObject:(id)theObject forClass:(Class)theClass {
  pthread_mutex_lock(&gObjectionMutex);
  [gObjectionContext setObject:[[[ObjectionInstanceEntry alloc] initWithObject:theObject] autorelease] forKey:NSStringFromClass(theClass)];
  pthread_mutex_unlock(&gObjectionMutex);
}

+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle {
  pthread_mutex_lock(&gObjectionMutex);
  if (lifeCycle != ObjectionInstantiationRule_Singleton && lifeCycle != ObjectionInstantiationRule_Everytime) {
    @throw [NSException exceptionWithName:@"ObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
  }
  
  if (theClass && [gObjectionContext objectForKey:NSStringFromClass(theClass)] == nil) {
   [gObjectionContext setObject:[ObjectionEntry withClass:theClass lifeCycle:lifeCycle andContext:self] forKey:NSStringFromClass(theClass)];
  } 
  pthread_mutex_unlock(&gObjectionMutex);
}

+ (id)getObject:(Class)theClass {
  pthread_mutex_lock(&gObjectionMutex);
  @try {
    NSString *key = NSStringFromClass(theClass);
    ObjectionEntry *entry = [gObjectionContext objectForKey:key];
    if (theClass && entry) {
      return [entry extractObject];
    } 
  }
  @finally {
    pthread_mutex_unlock(&gObjectionMutex);
  }
  
  return nil;

}

+ (void) reset {
  pthread_mutex_lock(&gObjectionMutex);
  [gObjectionContext removeAllObjects];
  pthread_mutex_unlock(&gObjectionMutex);
}
@end
