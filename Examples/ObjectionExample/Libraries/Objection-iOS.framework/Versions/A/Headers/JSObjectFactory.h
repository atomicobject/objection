#import <Foundation/Foundation.h>

@class JSObjectionInjector;

@interface JSObjectFactory : NSObject {
  JSObjectionInjector *_injector;
}

@property (nonatomic, readonly, retain) JSObjectionInjector *injector;

- (id)initWithInjector:(JSObjectionInjector *)injector;
- (id)getObject:(id)classOrProtocol;
@end
