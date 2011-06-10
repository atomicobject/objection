#import <Foundation/Foundation.h>
#import "ObjectionModule.h"

@interface ObjectionInjector : NSObject {
  NSDictionary *_globalContext;
  NSMutableDictionary *_context;
  NSSet *_eagerSingletons;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(ObjectionModule *)theModule;
- (id)getObject:(id)classOrProtocol;
@end
