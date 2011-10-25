#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectFactory.h"

#import <pthread.h>
#import <objc/runtime.h>

@interface __JSObjectionInjectorDefaultModule : JSObjectionModule
{
  JSObjectionInjector *_injector;
}
@end

@implementation __JSObjectionInjectorDefaultModule

- (id)initWithInjector:(JSObjectionInjector *)injector 
{
  if ((self = [super init])) {
    _injector = [injector retain];
  }
  return self;
}

- (void)configure 
{
  [self bind:[[[JSObjectFactory alloc] initWithInjector:_injector] autorelease] 
     toClass:[JSObjectFactory class]];
}

- (void)dealloc
{
  [_injector release];
  [super dealloc];
}
@end
  
@interface JSObjectionInjector(Private)
- (void)initializeEagerSingletons;
- (void)configureDefaultModule;
- (void)configureModule:(JSObjectionModule *)module;
@end

@implementation JSObjectionInjector

- (id)initWithContext:(NSDictionary *)theGlobalContext 
{
  if ((self = [super init])) {
    _globalContext = [theGlobalContext retain];
    _context = [[NSMutableDictionary alloc] init];
    [self configureDefaultModule];
    [self initializeEagerSingletons];
 }
  
  return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule 
{
  if ((self = [self initWithContext:theGlobalContext])) {
    [self configureModule:theModule];
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

#pragma mark - Private

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

- (void)configureModule:(JSObjectionModule *)module
{
  [module configure];
  NSSet *mergedSet = [module.eagerSingletons setByAddingObjectsFromSet:_eagerSingletons];
  [_eagerSingletons release];
  _eagerSingletons = [mergedSet retain];
  [_context addEntriesFromDictionary:module.bindings];
}

- (void)configureDefaultModule
{
  __JSObjectionInjectorDefaultModule *module = [[[__JSObjectionInjectorDefaultModule alloc] initWithInjector:self] autorelease];
  [self configureModule:module];
}

#pragma mark - 

- (void)dealloc {
  [_globalContext release];
  [_context release];  
  [_eagerSingletons release];
  [super dealloc];
}

@end
