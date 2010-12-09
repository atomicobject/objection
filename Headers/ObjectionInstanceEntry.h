#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"

@interface ObjectionInstanceEntry : NSObject<ObjectionEntry> {
	id instance;
}

- (id) initWithObject:(id)theObject;
- (id) extractObject;
@end
