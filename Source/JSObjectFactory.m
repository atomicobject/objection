#import "JSObjectFactory.h"
#import "Objection.h"

@implementation JSObjectFactory
@synthesize injector = _injector;

- (id)initWithInjector:(JSObjectionInjector *)injector {
  if ((self = [super init])) {
    _injector = injector;
  }
  return self;
}

- (id)getObject:(id)classOrProtocol
{
  return [self.injector getObject:classOrProtocol];
}
@end
