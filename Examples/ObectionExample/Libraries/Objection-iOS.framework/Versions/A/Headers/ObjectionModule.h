#import <Foundation/Foundation.h>

@class ObjectionInjector;

@protocol ObjectionProvider<NSObject>
- (id)createInstance:(ObjectionInjector *)context;
@end


@interface ObjectionModule : NSObject {
  NSMutableDictionary *_bindings;
  NSMutableSet *_eagerSingletons;
}

@property (nonatomic, readonly) NSDictionary *bindings;
@property (nonatomic, readonly) NSSet *eagerSingletons;

- (void)bind:(id)instance toClass:(Class)aClass;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<ObjectionProvider>)provider toClass:(Class)aClass;
- (void)bindProvider:(id<ObjectionProvider>)provider toProtocol:(Protocol *)aProtocol;
#if NS_BLOCKS_AVAILABLE
- (void)bindBlock:(id (^)(ObjectionInjector *context))block toClass:(Class)aClass;
- (void)bindBlock:(id (^)(ObjectionInjector *context))block toProtocol:(Protocol *)aProtocol;
#endif
- (void)registerEagerSingleton:(Class)klass;
- (void)configure;
@end