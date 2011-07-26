#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import <pthread.h>
#import <objc/runtime.h>

@interface JSObjectionInjector(Private)
- (void)initializeEagerSingletons;
@end

@implementation JSObjectionInjector

- (id)initWithContext:(NSDictionary *)theGlobalContext 
{
  if ((self = [super init])) {
    _globalContext = [theGlobalContext retain];
    _context = [[NSMutableDictionary alloc] init];
    _eagerSingletons = nil;
  }
  
  return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule 
{
  if ((self = [self initWithContext:theGlobalContext])) {
    [theModule configure];
    _eagerSingletons = theModule.eagerSingletons;
    [_context addEntriesFromDictionary:theModule.bindings];
    [self initializeEagerSingletons];
  }
  return self;
}

- (id)getObject:(id)classOrProtocol 
{
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
      return [injectorEntry extractObject];
    } 
    
    return nil;    
  }
  
  return nil;
}

- (void)initializeEagerSingletons 
{
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

- (void)dealloc {
  [_globalContext release]; _globalContext = nil;
  [_context release]; _context = nil;  
  [super dealloc];
}

@end
