#import <Foundation/Foundation.h>

@interface ObjectionInstanceEntry : NSObject {
	id instance;
}

- (id) initWithObject:(id)theObject;
- (id) extractObject;
@end
