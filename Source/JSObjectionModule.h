#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@class JSObjectionInjector;

@protocol JSObjectionProvider<NSObject>

- (id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments;

@end


@interface JSObjectionModule : NSObject

@property (nonatomic, readonly) NSDictionary *bindings;
@property (nonatomic, readonly) NSSet *eagerSingletons;

- (void)bind:(id)instance toClass:(Class)aClass;
- (void)bind:(id)instance toClass:(Class)aClass named:(NSString *)name;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol named:(NSString *)name;
- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass;
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass named:(NSString *)name;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol named:(NSString *)name;
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)bindProvider:(id<JSObjectionProvider>)provider toClass:(Class)aClass inScope:(JSObjectionScope)scope named:(NSString *)name;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope;
- (void)bindProvider:(id<JSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope named:(NSString *)name;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol named:(NSString*)name;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope named:(NSString*)name;
- (void)bindClass:(Class)aClass toClass:(Class)toClass;
- (void)bindClass:(Class)aClass toClass:(Class)toClass named:(NSString*)name;
- (void)bindClass:(Class)aClass toClass:(Class)toClass inScope:(JSObjectionScope)scope named:(NSString*)name;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass named:(NSString *)name;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol named:(NSString *)name;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toClass:(Class)aClass inScope:(JSObjectionScope)scope named:(NSString *)name;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope;
- (void)bindBlock:(id (^)(JSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol inScope:(JSObjectionScope)scope named:(NSString *)name;
- (void)bindClass:(Class)aClass inScope:(JSObjectionScope)scope;
- (void)registerEagerSingleton:(Class)aClass;
- (BOOL)hasBindingForClass:(Class)aClass;
- (BOOL)hasBindingForClass:(Class)aClass withName:(NSString*)name;
- (BOOL)hasBindingForProtocol:(Protocol *)protocol;
- (BOOL)hasBindingForProtocol:(Protocol *)protocol withName:(NSString*)name;
- (void)configure;

@end
