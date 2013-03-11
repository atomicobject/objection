#import "SpecHelper.h"
#import "InjectionErrorFixtures.h"
#import "Fixtures.h"

SPEC_BEGIN(InjectionErrorsSpecs)

beforeEach(^{
      JSObjectionInjector *injector = [JSObjection createInjector];
      [JSObjection setDefaultInjector:injector];
});

it(@"throws an exception if property type is not an object", ^{
      [[theBlock(^{
          [[JSObjection defaultInjector] getObject:[UnsupportedPropertyObject class]];    
      }) should] raiseWithReason:@"Unable to determine class type for property declaration: 'myInteger'"];
});

it(@"throws an exception if property cannot be found", ^{
      [[theBlock(^{
          [[JSObjection defaultInjector] getObject:[BadPropertyObject class]];
      }) should] raiseWithReason:@"Unable to find property declaration: 'badProperty' for class 'BadPropertyObject'"];
});

it(@"throws if an object requires a protocol that does not exist in the context", ^{
      [[theBlock(^{
          [[JSObjection defaultInjector] getObject:[FiveSpeedCar class]];
      }) should] raiseWithReason:@"Cannot find an instance that is bound to the protocol 'GearBox' to assign to the property 'gearBox'"];  
});

it(@"throws if instantiation rule is not valid", ^{  
      [[theBlock(^{
          [JSObjection registerClass:[CarFactory class] scope:3];  
      }) should] raiseWithReason:@"Invalid Instantiation Rule"];
});


SPEC_END