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
    _context = [[NSMutableDictionary alloc] initWithDictionary:initialContext copyItems:YES];
    [self configureContext];
  }
  
  return self;
}

- (id)getObject:(Class)theClass {
  NSString *key = NSStringFromClass(theClass);
  ObjectionEntry *entry = [_context objectForKey:key];
  if (theClass && entry) {
    return [entry extractObject];
  } 
  return nil;
}

- (void)dealloc {
  [_context release]; _context = nil;
  [super dealloc];
}

#pragma mark Private
#pragma mark -

- (void)configureContext {
  for (NSString *key in _context) {
    ObjectionEntry *entry = [_context objectForKey:key];
    entry.injector = self;
  }
}
@end
