#import <Foundation/Foundation.h>

@interface ObjectionModule : NSObject {
  NSMutableDictionary *_bindings;
  NSMutableSet *_eagerSingletons;
}

@property (nonatomic, readonly) NSDictionary *bindings;
@property (nonatomic, readonly) NSSet *eagerSingletons;

- (void)bind:(id)instance toClass:(Class)aClass;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol;
- (void)registerEagerSingleton:(Class)klass;
- (void)configure;
@end