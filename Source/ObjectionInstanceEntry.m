#import "ObjectionInstanceEntry.h"


@implementation ObjectionInstanceEntry
- (id) initWithObject:(id)theObject {
  if (self = [super init]) {
		instance = [theObject retain];    
  }
  return self;
}

- (id) extractObject {
  return instance;
}

- (ObjectionInstantiationRule) lifeCycle {
  return ObjectionInstantiationRuleSingleton;
}

- (void)dealloc {
  [instance release]; instance = nil;
  [super dealloc];
}

@end
