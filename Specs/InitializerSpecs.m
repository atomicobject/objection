#import "SpecHelper.h"
#import "InitializerFixtures.h"
#import "ModuleFixtures.h"

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

it(@"is OK to register an object with an initializer without any default arguments", ^{
    ConfigurableCar *car = [injector getObjectWithArgs:[ConfigurableCar class], @"Passat", [NSNumber numberWithInt:200], [NSNumber numberWithInt:2002], nil];
    
    [[car.horsePower should] equal:[NSNumber numberWithInt:200]];
    [[car.model should] equal:@"Passat"];
    [[car.year should] equal:[NSNumber numberWithInt:2002]];
    [[car.engine should] beMemberOfClass:[Engine class]];    
});

it(@"raises an exception if the initializer is not valid", ^{
   [[theBlock(^{
       [injector getObject:[BadInitializer class]];
   }) should] raiseWithReason:@"Could not find initializer 'initWithNonExistentInitializer' on BadInitializer"];
});

it(@"uses configured dependencies when calling initializer", ^{
    CarWithInitializerDependencies * service = [injector getObject:[CarWithInitializerDependencies class]];
    [[theValue(service.hasEngine) should] beTrue];
    [service.gearBox shouldNotBeNil];
});

it(@"will override the default arguments also for initializer dependencies", ^{
    Engine * eng = [[Engine new] autorelease];
    CarWithInitializerDependencies * service = [injector getObjectWithArgs:[CarWithInitializerDependencies class],
                    eng, [[AfterMarketGearBox new] autorelease], nil];

    [[eng should] equal:service.engine];
});

it(@"allows overriding a default argument with a dependency" , ^{
    ProviderModule *const module = [[ProviderModule new] autorelease];
    injector = [JSObjection createInjectorWithModules:module, nil];

    CarWithInitializerDependencies * service = [injector getObjectWithArgs:[CarWithInitializerDependencies class],
                    classDependency(Engine),
                    protocolDependency(GearBox), nil];

    [service.gearBox shouldNotBeNil];
});

it(@"throws when passing in a dependency that is not registered" , ^{
    [[theBlock(^{
        [injector getObjectWithArgs:[CarWithInitializerDependencies class],
                        classDependency(Engine),
                        protocolDependency(GearBox), nil];
    }
    ) should] raiseWithReason:@"A required initializer dependency was not found"];

});


        SPEC_END