#import "JSObjectionProviderEntry.h"

@interface JSObjectionProviderEntry () {
  id<JSObjectionProvider> _provider;
  id(^_block)(JSObjectionInjector *context);
  JSObjectionScope _lifeCycle;
  id _storageCache;
}

@end

@implementation JSObjectionProviderEntry
@synthesize lifeCycle = _lifeCycle;

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider lifeCycle:(JSObjectionScope)theLifeCycle {
    if ((self = [super init])) {
        _provider = theProvider;
        _lifeCycle = theLifeCycle;
        _storageCache = nil;
    }

    return self;
}

- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock lifeCycle:(JSObjectionScope)theLifeCycle {
    if ((self = [super init])) {
        _block = [theBlock copy];
        _lifeCycle = theLifeCycle;
        _storageCache = nil;
    }

    return self;  
}

- (id)extractObject:(NSArray *)arguments {
    if (self.lifeCycle == JSObjectionScopeNormal || !_storageCache) {
        return [self buildObject:arguments];
    }

    return _storageCache;
}

- (void)dealloc {
    _storageCache = nil;
}

- (id)buildObject:(NSArray *)arguments {
    id objectUnderConstruction = nil;
    if (_block) {
        objectUnderConstruction = _block(self.injector);
    }
    else {
        objectUnderConstruction = [_provider provide:self.injector arguments:arguments];
    }
    if (self.lifeCycle == JSObjectionScopeSingleton) {
        _storageCache = objectUnderConstruction;
    }
    return objectUnderConstruction;
}

@end
