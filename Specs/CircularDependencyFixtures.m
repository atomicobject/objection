#import "Objection.h"
#import "CircularDependencyFixtures.h"
#import "Fixtures.h"

@implementation SingletonBar
objection_register_singleton(SingletonBar)
objection_requires(@"foo")

@synthesize foo;
@end