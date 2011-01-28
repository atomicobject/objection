#import <Foundation/Foundation.h>

@interface ObjectionModule : NSObject {
  NSMutableDictionary *_bindings;
}

@property (nonatomic, readonly) NSDictionary *bindings;

- (void) bind:(id)instance toClass:(Class)aClass;
- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void) configure;
@end