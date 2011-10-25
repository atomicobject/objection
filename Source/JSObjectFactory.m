#import "JSObjectFactory.h"
#import "Objection.h"

@interface JSObjectFactory()
@property (nonatomic, assign) JSObjectionInjector *injector;
@end

@implementation JSObjectFactory
objection_register_singleton(JSObjectFactory)
objection_requires(@"injector")

@synthesize injector = _injector;

- (id)getObject:(id)classOrProtocol
{
  return [self.injector getObject:classOrProtocol];
}
@end
