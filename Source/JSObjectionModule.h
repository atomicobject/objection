#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@class JSObjectionInjector;

@protocol JSObjectionProvider<NSObject>
- (id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments;
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
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol;
- (void)bindClass:(Class)aClass toClass:(Class)toClass;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope;
- (void)bindClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)registerEagerSingleton:(Class)aClass;
- (BOOL)hasBindingForClass:(Class)aClass;
- (BOOL)hasBindingForProtocol:(Protocol *)protocol;
- (void)configure;
@end