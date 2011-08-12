#import "SpecHelper.h"
#import "InjectionErrorFixtures.h"
#import "Fixtures.h"

SPEC_BEGIN(InjectionErrorsSpecs)

beforeEach(^{
  JSObjectionInjector *injector = [JSObjection createInjector];
  [JSObjection setGlobalInjector:injector];
});

it(@"throws an exception if property type is not an object", ^{
  [[theBlock(^{
    [[JSObjection globalInjector] getObject:[UnsupportedPropertyObject class]];    
  }) should] raiseWithReason:@"Unable to determine class type for property declaration: 'myInteger'"];
});

it(@"throws an exception if property cannot be found", ^{
  [[theBlock(^{
    [[JSObjection globalInjector] getObject:[BadPropertyObject class]];
  }) should] raiseWithReason:@"Unable to find property declaration: 'badProperty'"];
});

it(@"throws if an object requires a protocol that does not exist in the context", ^{
  [[theBlock(^{
    [[JSObjection globalInjector] getObject:[ManualCar class]];
  }) should] raiseWithReason:@"Cannot find an instance that is bound to the protocol 'GearBox' to assign to the property 'gearBox'"];
  
});

it(@"throws if instantiation rule is not valid", ^{  
  [[theBlock(^{
    [JSObjection registerClass:[CarFactory class] lifeCycle:3];  
  }) should] raiseWithReason:@"Invalid Instantiation Rule"];
});


SPEC_END