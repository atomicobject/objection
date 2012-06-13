#import "SpecHelper.h"
#import <objc/runtime.h>
#import "Fixtures.h"
#import "InitializerFixtures.h"

SPEC_BEGIN(BasicUsageSpecs)
beforeEach(^{
      JSObjectionInjector *injector = [JSObjection createInjector];
      [JSObjection setDefaultInjector:injector];
});

it(@"correctly builds a registered object", ^{
      id engine = [[JSObjection defaultInjector] getObject:[Engine class]];
      
      assertThat(engine, isNot(nilValue()));
});

it(@"returns nil for a non-registered object", ^{
      Class newClass = objc_allocateClassPair([NSObject class], "MyFooClass", 0);
      objc_registerClassPair(newClass);
      assertThat([[JSObjection defaultInjector] getObject:newClass], is(nilValue()));
});

it(@"correctly builds and object with dependencies", ^{
      Car *car = [[JSObjection defaultInjector] getObject:[Car class]];
      
      assertThat(car, isNot(nilValue()));
      
      assertThat(car.engine, isNot(nilValue()));
      assertThat(car.engine, is(instanceOf([Engine class])));
      
      assertThat(car.brakes, isNot(nilValue()));
      assertThat(car.brakes, is(instanceOf([Brakes class])));
});

it(@"defaults to returning a new instance", ^{
      id thomas = [[JSObjection defaultInjector] getObject:[Engine class]];
      id gordan = [[JSObjection defaultInjector] getObject:[Engine class]];
      
      assertThat(thomas, isNot(sameInstance(gordan)));
});

it(@"will return the same instance if it is registered as a singleton", ^{
      id carFactory1 = [[JSObjection defaultInjector] getObject:[CarFactory class]];
      id carFactory2 = [[JSObjection defaultInjector] getObject:[CarFactory class]];
      
      assertThat(carFactory1, isNot(nilValue()));
      assertThat(carFactory1, is(sameInstance(carFactory2)));
});

it(@"ensures that singletons are properly registered even if they have not been referenced", ^{
      // Ensure that the class is initialized before attempting to retrieve it.  
      id holder1 = [[JSObjection defaultInjector] getObject:[SingletonItemHolder class]];
      id holder2 = [[JSObjection defaultInjector] getObject:[SingletonItemHolder class]];  
      
      assertThat([holder1 singletonItem], is(sameInstance([holder2 singletonItem])));
});

it(@"will not return the same instance per injector if object is a singleton", ^{
      id carFactory1 = [[JSObjection defaultInjector] getObject:[CarFactory class]];
      id carFactory2 = [[JSObjection createInjector] getObject:[CarFactory class]];
      assertThat(carFactory1, isNot(sameInstance(carFactory2)));
});

it(@"returns nil if the class is nil", ^{
    assertThat([[JSObjection defaultInjector] getObject:nil], is(nilValue()));
});

it(@"doesn't blow up if a nil class is passed into register", ^{
    [JSObjection registerClass:nil lifeCycle:JSObjectionInstantiationRuleSingleton];
});

it(@"calls awakeFromObjection when an object has been constructed", ^{
      id engine = [[JSObjection defaultInjector] getObject:[Engine class]];
      id car = [[JSObjection defaultInjector] getObject:[Car class]];

      assertThatBool([engine awake], equalToBool(YES));
      assertThatBool([car awake], equalToBool(YES));
});


describe(@"object factory", ^{
    it(@"injector returns a JSObjectFactory for the given injector context", ^{
        JSObjectionInjector *injector1 = [JSObjection createInjector];
        JSObjectionInjector *injector2 = [JSObjection defaultInjector];
        
        JSObjectFactoryHolder *holder1 = [injector1 getObject:[JSObjectFactoryHolder class]];
        JSObjectFactoryHolder *holder2 = [injector2 getObject:[JSObjectFactoryHolder class]];
        
        SingletonItem *item1 = [holder1.objectFactory getObject:[SingletonItem class]];
        SingletonItem *item2 = [holder2.objectFactory getObject:[SingletonItem class]];
        
        [[item1 shouldNot] equal:item2];
    });    
    
    it(@"can take variadic arguments and pass them along to the injector", ^{
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        JSObjectFactory *factory = [injector getObject:[JSObjectFactory class]];
        
        ConfigurableCar *car = [factory getObjectWithArgs:[ConfigurableCar class], @"Model", @"Power", @"Year", nil];
        
        [[car.model should] equal:@"Model"];
        [[car.horsePower should] equal:@"Power"];
        [[car.year should] equal:@"Year"];
        
    });
});

SPEC_END