#import "JSObjectionDependency.h"


@interface JSObjectionDependency ()
@property(readwrite, assign) id dependentType;

@end

@implementation JSObjectionDependency
{
}
@synthesize dependentType = _dependentType;

- (id) initWithType:(id)dependentType
{
    self = [super init];
    if (self)
        self.dependentType = dependentType;
    return self;
}

+ (JSObjectionDependency *)for:(id)classOrProtocol
{
    return [[[JSObjectionDependency  alloc] initWithType:classOrProtocol] autorelease];
}


@end