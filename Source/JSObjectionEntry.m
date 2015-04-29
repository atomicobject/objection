#import "JSObjectionEntry.h"

@implementation JSObjectionEntry

@synthesize injector;
@dynamic lifeCycle;

- (id)extractObject:(NSArray *)arguments {
    return nil;
}

+ (id)entryWithEntry:(JSObjectionEntry *)entry {
    return entry;
}

- (JSObjectionScope)lifeCycle {
    return JSObjectionScopeNone;
}
@end
