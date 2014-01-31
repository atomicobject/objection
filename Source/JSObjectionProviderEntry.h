#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"
#import "JSObjectionModule.h"

@class JSObjectionInjector;

@interface JSObjectionProviderEntry : JSObjectionEntry {
    id<JSObjectionProvider> _provider;
    id(^_block)(JSObjectionInjector *context);
    JSObjectionScope _lifeCycle;
    id _storageCache;
}

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider lifeCycle:(JSObjectionScope)theLifeCycle;
- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock lifeCycle:(JSObjectionScope)theLifeCycle;
@end
