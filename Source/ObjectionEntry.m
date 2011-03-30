#import "ObjectionEntry.h"

@implementation ObjectionEntry
@synthesize injector = _injector;
@dynamic lifeCycle;

- (id)extractObject {
  return nil;
}

+ (id)entryWithEntry:(ObjectionEntry *)entry {
  return [[entry retain] autorelease];
}

- (ObjectionInstantiationRule)lifeCycle {
  return ObjectionInstantiationRuleNone;
}
@end
