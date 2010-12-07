#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"
#import "ObjectionEntry.h"
#import <pthread.h>

@interface ObjectionInjector(Private)
- (void)configureContext;
@end

@implementation ObjectionInjector
- (id)initWithContext:(NSDictionary *)initialContext {
  if ((self = [super init])) {
    _globalContext = [initialContext retain];
    _context = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

- (id)getObject:(Class)theClass {
  NSString *key = NSStringFromClass(theClass);
  ObjectionEntry *injectorEntry = [_context objectForKey:key];
  
  if (!injectorEntry) {
    ObjectionEntry *entry = [_globalContext objectForKey:key];
    if (entry) {
      injectorEntry = [entry copy];
      injectorEntry.injector = self;
      [_context setObject:injectorEntry forKey:key];      
    }
  }
  
  if (theClass && injectorEntry) {
    return [injectorEntry extractObject];
  } 
  
  return nil;
}

- (void)dealloc {
  [_globalContext release]; _globalContext = nil;
  [_context release]; _context = nil;  
  [super dealloc];
}

@end
