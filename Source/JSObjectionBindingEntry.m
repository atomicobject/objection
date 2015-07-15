#import "JSObjectionBindingEntry.h"

@interface JSObjectionBindingEntry () {
  id _instance;
}

@end

@implementation JSObjectionBindingEntry

- (instancetype)initWithObject:(id)theObject {
    if ((self = [super init])) {
        _instance = theObject;    
    }
    return self;
}

- (id)extractObject:(NSArray *)arguments {
    return _instance;
}

- (JSObjectionScope)lifeCycle {
    return JSObjectionScopeSingleton;
}

- (void)dealloc {
     _instance = nil;
}

@end
