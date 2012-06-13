#import "SpecHelper.h"
#import "InitializerFixtures.h"

SPEC_BEGIN(InitializerSpecs)
__block JSObjectionInjector *injector = nil;

beforeEach(^{
    injector = [JSObjection createInjector];
});

it(@"instantiates the object with the default initializer arguments", ^{
    ViewController *controller = [injector getObject:[ViewController class]];
    
    [[controller.nibName should] equal:@"MyNib"];
    assertThat(controller.bundle, nilValue());
    [[controller.car should] beMemberOfClass:[Car class]];
});

it(@"will override the default arguments if arguments are passed to the injector", ^{
    ViewController *controller = [injector getObjectWithArgs:[ViewController class], @"AnotherNib", @"pretendBundle", nil];
    
    [[controller.nibName should] equal:@"AnotherNib"];
    [[controller.bundle should] equal:@"pretendBundle"];
    [[controller.car should] beMemberOfClass:[Car class]];    
});

it(@"is happy to instantiate an object with a number of initializer arguments", ^{
    
});

SPEC_END