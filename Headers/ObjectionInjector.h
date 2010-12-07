#import <Foundation/Foundation.h>

@interface ObjectionInjector : NSObject {
  NSMutableDictionary *_context;
}

- (id)initWithContext:(NSDictionary *)initialContext;
- (id) getObject:(Class)theClass;
@end
