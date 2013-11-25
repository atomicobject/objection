#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"


SPEC_BEGIN(AddAndRemoveModulesSpecs)
__block SecondModule *module = nil;
__block JSObjectionInjector *injector = nil;

beforeEach(^{
    module = [[SecondModule alloc] init];
    gEagerSingletonHook = NO;
    injector = [JSObjection createInjector:module];
});

it(@"builds a new injector with new modules", ^{
    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([FiveSpeedCar class])));
    assertThatBool(gEagerSingletonHook, equalToBool(NO));

    injector = [injector withModules:
                    [[ProviderModule alloc] init],
                    [[FirstModule alloc] init], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([FiveSpeedCar class])));
    assertThatBool(gEagerSingletonHook, equalToBool(YES));
});

it(@"builds a new module without the module types", ^{
    injector = [injector withModules:
                [[ProviderModule alloc] init], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([FiveSpeedCar class])));

    injector = [injector withoutModuleOfTypes:[SecondModule class], [ProviderModule class], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(nilValue()));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([FiveSpeedCar class])));
});

it(@"builds a new injector and appends new modules ", ^{
    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([FiveSpeedCar class])));
    assertThatBool(gEagerSingletonHook, equalToBool(NO));

    [injector appendModules:
            [[ProviderModule alloc] init],
            [[FirstModule alloc] init], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([FiveSpeedCar class])));
    assertThatBool(gEagerSingletonHook, equalToBool(YES));
});

it(@"builds a new injector and removes modules", ^{
    injector = [injector withModules:
            [[FirstModule alloc] init],
            [[SecondModule alloc] init],
            [[ProviderModule alloc] init], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([FiveSpeedCar class])));

    [injector removeModuleOfTypes:[SecondModule class], [ProviderModule class], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(nilValue()));
    assertThat([injector getObject:[Car class]], isNot(instanceOf([FiveSpeedCar class])));
});

SPEC_END
