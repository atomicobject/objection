#import "JSObjectionProviderEntry.h"


@implementation JSObjectionProviderEntry

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider
{
  if ((self = [super init])) {
    _provider = [theProvider retain];
  }
  
  return self;
}

#if NS_BLOCKS_AVAILABLE
- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock
{
  if ((self = [super init])) {
    _block = [theBlock copy];
  }

  return self;  
}
#endif

- (id)extractObject
{
#if NS_BLOCKS_AVAILABLE
  if (_block) {
    return _block(self.injector);
  }
#endif
  return [_provider createInstance:self.injector];
}

- (void)dealloc
{
  [_provider release];
#if NS_BLOCKS_AVAILABLE
  [_block release];
#endif
  [super dealloc];
}
@end
