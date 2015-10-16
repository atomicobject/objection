#import "InjectionErrorFixtures.h"
#import "Objection.h"

@implementation UnsupportedPropertyObject
objection_register(UnsupportedPropertyObject)
objection_requires(@"myInteger")
@synthesize myInteger;

@end

@implementation BadPropertyObject
@synthesize someObject;
objection_register(BadPropertyObject)
objection_requires(@"badProperty")
@end

@implementation ReadOnlyPropertyObject
objection_register(ReadOnlyPropertyObject)
objection_requires(@"someObject")

@synthesize someObject=_someObject;
@end

@implementation NamedUnsupportedPropertyObject
objection_register(NamedUnsupportedPropertyObject)
objection_requires_names((@{@"MyInteger":@"myInteger"}));
@synthesize myInteger;

@end

@implementation NamedBadPropertyObject
@synthesize someObject;
objection_register(BadPropertyObject)
objection_requires_names((@{@"BadProperty":@"badProperty"}))
@end

