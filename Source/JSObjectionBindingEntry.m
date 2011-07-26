#import "JSObjectionBindingEntry.h"


@implementation JSObjectionBindingEntry

- (id)initWithObject:(id)theObject 
{
  if ((self = [super init])) {
		_instance = [theObject retain];    
  }
  return self;
}

- (id)extractObject 
{
  return _instance;
}

- (JSObjectionInstantiationRule)lifeCycle 
{
  return JSObjectionInstantiationRuleSingleton;
}

- (void)dealloc 
{
  [_instance release]; _instance = nil;
  [super dealloc];
}

@end
