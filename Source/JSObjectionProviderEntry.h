#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"
#import "JSObjectionModule.h"

@class JSObjectionInjector;

@interface JSObjectionProviderEntry : JSObjectionEntry {
    id<JSObjectionProvider> _provider;
    id(^_block)(JSObjectionInjector *context);
}

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider;
- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock;
@end
