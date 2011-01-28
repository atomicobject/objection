#import <Foundation/Foundation.h>
#import "ObjectionModule.h"

@interface ObjectionInjector : NSObject {
  NSDictionary *_globalContext;
  NSMutableDictionary *_context;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(ObjectionModule *)theModule;
- (id) getObject:(id)classOrProtocol;
@end
