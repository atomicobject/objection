#import <Foundation/Foundation.h>

@interface ObjectionInjector : NSObject {
  NSDictionary *_globalContext;
  NSMutableDictionary *_context;
}

- (id)initWithContext:(NSDictionary *)initialContext;
- (id) getObject:(Class)theClass;
@end
