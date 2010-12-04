#import "SpecHelper.h"
#import <objc/runtime.h>
#import "Fixtures.h"

SPEC_BEGIN(BasicUsageSpecs)

it(@"correctly builds a registered object", ^{
  id engine = [ObjectionInjector getObject:[Engine class]];
  
  assertThat(engine, isNot(nilValue()));
});

it(@"returns nil for a non-registered object", ^{
  Class newClass = objc_allocateClassPair([NSObject class], "MyFooClass", 0);
  assertThat([ObjectionInjector getObject:newClass], is(nilValue()));
});

it(@"correctly builds and object with dependencies", ^{
  Car *car = [ObjectionInjector getObject:[Car class]];
  
  assertThat(car, isNot(nilValue()));
  
  assertThat(car.engine, isNot(nilValue()));
  assertThat(car.engine, is(instanceOf([Engine class])));
  
  assertThat(car.brakes, isNot(nilValue()));
  assertThat(car.brakes, is(instanceOf([Brakes class])));
});

it(@"defaults to returning a new instance", ^{
  id thomas = [ObjectionInjector getObject:[Engine class]];
  id gordan = [ObjectionInjector getObject:[Engine class]];
  
  assertThat(thomas, isNot(sameInstance(gordan)));
});

it(@"will return the same instance if it is registered as a singleton", ^{
  id carFactory1 = [ObjectionInjector getObject:[CarFactory class]];
  id carFactory2 = [ObjectionInjector getObject:[CarFactory class]];
  
  assertThat(carFactory1, isNot(nilValue()));
  assertThat(carFactory1, is(sameInstance(carFactory2)));
});

it(@"returns nil if the class is nil", ^{
  assertThat([ObjectionInjector getObject:nil], is(nilValue()));
});

it(@"doesn't blow up if a nil class is passed into register", ^{
  [ObjectionInjector registerClass:nil lifeCycle:ObjectionInstantiationRule_Singleton];
});

it(@"can register an existing instance with a class", ^{
  [ObjectionInjector registerObject:@"my string" forClass:[NSString class]];
  assertThat([ObjectionInjector getObject:[NSString class]], is(@"my string"));
});

it(@"calls awakeFromObjection when object has constructed", ^{
  id engine = [ObjectionInjector getObject:[Engine class]];
  id car = [ObjectionInjector getObject:[Car class]];

  assertThatBool([engine awake], equalToBool(YES));
  assertThatBool([car awake], equalToBool(YES));
});

SPEC_END