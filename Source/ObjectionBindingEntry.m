#import "ObjectionBindingEntry.h"


@implementation ObjectionBindingEntry
- (id) initWithObject:(id)theObject {
  if ((self = [super init])) {
		_instance = [theObject retain];    
  }
  return self;
}

- (id)extractObject {
  return _instance;
}

- (ObjectionInstantiationRule)lifeCycle {
  return ObjectionInstantiationRuleSingleton;
}

- (void)dealloc {
  [_instance release]; _instance = nil;
  [super dealloc];
}

@end
