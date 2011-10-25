#import <Foundation/Foundation.h>

@class JSObjectionInjector;

@interface JSObjectFactory : NSObject {
  JSObjectionInjector *_injector;
}

- (id)getObject:(id)classOrProtocol;
@end
