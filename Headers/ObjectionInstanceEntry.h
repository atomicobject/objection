@interface ObjectionInstanceEntry : NSObject {
	id instance;
}

- (id) initWithObject:(id)theObject;
- (id) extractObject;
@end
