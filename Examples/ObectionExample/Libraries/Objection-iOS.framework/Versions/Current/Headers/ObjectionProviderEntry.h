#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"
#import "ObjectionModule.h"

@class ObjectionInjector;

@interface ObjectionProviderEntry : ObjectionEntry {
  id<ObjectionProvider> _provider;
#if NS_BLOCKS_AVAILABLE
  id(^_block)(ObjectionInjector *context);
#endif
}

- (id)initWithProvider:(id<ObjectionProvider>)theProvider;
#if NS_BLOCKS_AVAILABLE
- (id)initWithBlock:(id(^)(ObjectionInjector *context))theBlock;
#endif
@end
