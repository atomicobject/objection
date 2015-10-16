#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"


QuickSpecBegin(AddAndRemoveModulesSpecs)
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
    assertThatBool(gEagerSingletonHook, isFalse());
    
    injector = [injector withModules:
                    [[ProviderModule alloc] init],
                    [[FirstModule alloc] init], nil];

    assertThat([injector getObject:@protocol(GearBox)], is(instanceOf([AfterMarketGearBox class])));
    assertThat([injector getObject:[Car class]], is(instanceOf([FiveSpeedCar class])));
    assertThatBool(gEagerSingletonHook, isTrue());
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

QuickSpecEnd