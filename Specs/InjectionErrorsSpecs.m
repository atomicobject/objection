#import "SpecHelper.h"
#import "InjectionErrorFixtures.h"
#import "Fixtures.h"

QuickSpecBegin(InjectionErrorsSpecs)


beforeEach(^{
      JSObjectionInjector *injector = [JSObjection createInjector];
      [JSObjection setDefaultInjector:injector];
});

it(@"throws an exception if property type is not an object", ^{
    expectAction([[JSObjection defaultInjector] getObject:[UnsupportedPropertyObject class]]).to(raiseException().reason(@"Unable to determine class type for property declaration: 'myInteger'"));
});

it(@"throws an exception if property cannot be found", ^{
    expectAction([[JSObjection defaultInjector] getObject:[BadPropertyObject class]]).to(raiseException().reason(@"Unable to find property declaration: 'badProperty' for class 'BadPropertyObject'"));
});

it(@"throws if an object requires a protocol that does not exist in the context", ^{
    expectAction([[JSObjection defaultInjector] getObject:[FiveSpeedCar class]]).to(raiseException().reason(@"Cannot find an instance that is bound to the protocol 'GearBox' to assign to the property 'gearBox'"));
});

it(@"throws if instantiation rule is not valid", ^{
    expectAction([JSObjection registerClass:[CarFactory class] scope:3]).to(raiseException().reason(@"Invalid Instantiation Rule"));
});

describe(@"named properties",^{
      beforeEach(^{
          JSObjectionInjector *injector = [JSObjection createInjector];
          [JSObjection setDefaultInjector:injector];
      });

      it(@"throws an exception if property type is not an object", ^{
            expectAction([[JSObjection defaultInjector] getObject:[NamedUnsupportedPropertyObject class]]).to(raiseException().reason(@"Unable to determine class type for property declaration: 'myInteger'"));
      });

      it(@"throws an exception if property cannot be found", ^{
          expectAction([[JSObjection defaultInjector] getObject:[NamedBadPropertyObject class]]).to(raiseException().reason(@"Unable to find property declaration: 'badProperty' for class 'NamedBadPropertyObject'"));
      });
});


QuickSpecEnd