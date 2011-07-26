#import <Foundation/Foundation.h>
#import "JSObjectionModule.h"

@interface JSObjectionInjector : NSObject {
  NSDictionary *_globalContext;
  NSMutableDictionary *_context;
  NSSet *_eagerSingletons;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule;
- (id)getObject:(id)classOrProtocol;
@end
