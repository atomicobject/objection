#import "SpecHelper.h"
#import "InjectionErrorFixtures.h"
#import "Fixtures.h"

SPEC_BEGIN(InjectionErrorsSpecs)

beforeEach(^{
  ObjectionInjector *injector = [Objection createInjector];
  [Objection setGlobalInjector:injector];
});
//
//it(@"throws an exception if property type if not an object", ^{
//  @try {
//    [[Objection globalInjector] getObject:[UnsupportedPropertyObject class]];
//    fail(@"Should have thrown an exception");
//  }
//  @catch (NSException * e) {
//    assertThat([e reason], is(@"Unable to determine class type for property declaration: 'myInteger'"));
//  }
//});
//
//it(@"throws an exception if property cannot be found", ^{
//  @try {
//    [[Objection globalInjector] getObject:[BadPropertyObject class]];
//    fail(@"Should have thrown an exception");
//  }
//  @catch (NSException * e) {
//    assertThat([e reason], is(@"Unable to find property declaration: 'badProperty'"));
//  }
//  
//});
//
//it(@"throws if instantiation rule if not valid", ^{  
//  @try {
//    [Objection registerClass:[CarFactory class] lifeCycle:3];  
//    fail(@"Should have thrown an exception");
//  }
//  @catch (NSException * e) {
//    assertThat([e reason], is(@"Invalid Instantiation Rule"));
//  }
//});
//

SPEC_END