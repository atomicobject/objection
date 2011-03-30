#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"

@interface ObjectionBindingEntry : ObjectionEntry {
	id _instance;
}

- (id)initWithObject:(id)theObject;
- (id)extractObject;
@end
