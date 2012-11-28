#import <Foundation/Foundation.h>

@class JSObjectionInjector;

@protocol JSObjectionProvider<NSObject>
- (id)provide:(JSObjectionInjector *)context;
@end


@interface JSObjectionModule : NSObject {
    NSMutableDictionary *_bindings;
    NSMutableSet *_eagerSingletons;
}

@property (nonatomic, readonly) NSDictionary *bindings;
@property (nonatomic, readonly) NSSet *eagerSingletons;

- (void)bind:(id)instance toClass:(Class)aClass;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol asSingleton:(BOOL)singleton;
- (void)bindClass:(Class)aClass toClass:(Class)toClass asSingleton:(BOOL)singleton;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol;

- (void)registerSingleton:(Class)aClass;
- (void)registerEagerSingleton:(Class)aClass;

- (void)configure:(JSObjectionInjector *)injector;

- (void)unload;
- (void)reset;

@end