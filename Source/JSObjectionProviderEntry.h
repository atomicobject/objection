#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"
#import "JSObjectionModule.h"

@class JSObjectionInjector;

@interface JSObjectionProviderEntry : JSObjectionEntry {
  id<JSObjectionProvider> _provider;
#if NS_BLOCKS_AVAILABLE
  id(^_block)(JSObjectionInjector *context);
#endif
}

- (id)initWithProvider:(id<JSObjectionProvider>)theProvider;
#if NS_BLOCKS_AVAILABLE
- (id)initWithBlock:(id(^)(JSObjectionInjector *context))theBlock;
#endif
@end
