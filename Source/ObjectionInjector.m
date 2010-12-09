#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"
#import "ObjectionEntry.h"
#import <pthread.h>

@interface ObjectionInjector(Private)
- (void)configureContext;
@end

@implementation ObjectionInjector

- (id)initWithContext:(NSDictionary *)theGlobalContext {
  if ((self = [super init])) {
    _globalContext = [theGlobalContext retain];
    _context = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(ObjectionModule *)theModule {
  if (self = [self initWithContext:theGlobalContext]) {
    [theModule configure];
    [_context addEntriesFromDictionary:theModule.bindings];
  }
  return self;
}

- (id)getObject:(Class)theClass {
  @synchronized(self) {
    
    NSString *key = NSStringFromClass(theClass);
    id<ObjectionEntry> injectorEntry = [_context objectForKey:key];
    
    if (!injectorEntry) {
      id<ObjectionEntry> entry = [_globalContext objectForKey:key];
      if ([entry isKindOfClass:[ObjectionEntry class]]) {
        injectorEntry = [ObjectionEntry entryWithEntry:entry];
        ((ObjectionEntry *)injectorEntry).injector = self;
        [_context setObject:injectorEntry forKey:key];      
      }
    }
    
    if (theClass && injectorEntry) {
      return [injectorEntry extractObject];
    } 
    
    return nil;    
  }
}

- (void)dealloc {
  [_globalContext release]; _globalContext = nil;
  [_context release]; _context = nil;  
  [super dealloc];
}

@end
