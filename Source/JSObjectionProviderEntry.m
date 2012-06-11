#import "JSObjectionProviderEntry.h"


@implementation JSObjectionProviderEntry

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider {
    if ((self = [super init])) {
        _provider = [theProvider retain];
    }

    return self;
}

- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock {
    if ((self = [super init])) {
        _block = [theBlock copy];
    }

    return self;  
}

- (id)extractObject:(NSArray *)arguments {
    if (_block) {
        return _block(self.injector);
    }
    return [_provider provide:self.injector];
}

- (void)dealloc {
    [_provider release];
    [_block release];
    [super dealloc];
}
@end
