#import "JSObjectionEntry.h"

@implementation JSObjectionEntry
@synthesize injector = _injector;
@dynamic lifeCycle;

- (id)extractObject:(NSArray *)arguments {
    return nil;
}

+ (id)entryWithEntry:(JSObjectionEntry *)entry {
    return [[entry retain] autorelease];
}

- (JSObjectionScope)lifeCycle {
    return JSObjectionScopeNone;
}
@end
