#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"

SPEC_BEGIN(ModuleUsageSpecs)
__block MyModule *module = nil;

beforeEach(^{
    Engine *engine = [[Engine alloc] init];
    id<GearBox> gearBox = [[AfterMarketGearBox alloc] init];

    module = [[MyModule alloc] initWithEngine:engine andGearBox:gearBox];    
    gEagerSingletonHook = NO;
    JSObjectionInjector *injector = [JSObjection createInjector:module];
    [JSObjection setDefaultInjector:injector];
});

it(@"merges the modules instance bindings with the injector's context", ^{
    assertThat([[JSObjection defaultInjector] getObject:[Engine class]], is(sameInstance(module.engine)));
});

it(@"uses the module's bounded instance to fill out other objects dependencies", ^{
    FiveSpeedCar *car = [[JSObjection defaultInjector] getObject:[FiveSpeedCar class]];

    assertThat(car.engine, is(sameInstance(module.engine)));    
    assertThat(car.gearBox, is(sameInstance(module.gearBox)));    
});

it(@"supports binding an instance to a protocol", ^{
    assertThat([[JSObjection defaultInjector] getObject:@protocol(GearBox)], is(sameInstance(module.gearBox)));    
});

it(@"throws an exception if the instance does not conform to the protocol", ^{
    Engine *engine = [[Engine alloc] init];

    [[theBlock(^{
        MyModule *module = [[MyModule alloc] initWithEngine:engine andGearBox:(id)@"no go"];
        [module configure];
    }) should] raiseWithReason:@"Instance does not conform to the GearBox protocol"];
});

it(@"supports eager singletons", ^{
    assertThatBool(gEagerSingletonHook, equalToBool(YES));
});

it(@"throws an exception if an attempt is made to register an eager singleton that was not registered as a singleton", ^{
    Engine *engine = [[Engine alloc] init];

    [[theBlock(^{
        id<GearBox> gearBox = [[AfterMarketGearBox alloc] init];
        MyModule *module = [[MyModule alloc] initWithEngine:engine andGearBox:gearBox];    
        module.instrumentInvalidEagerSingleton = YES;
        [JSObjection createInjector:module];
    }) should] raiseWithReason:@"Unable to initialize eager singleton for the class 'Car' because it was never registered as a singleton"];

});

describe(@"provider bindings", ^{
  __block ProviderModule *providerModule = nil;
  
  beforeEach(^{
    providerModule = [[ProviderModule alloc] init];    
    JSObjectionInjector *injector = [JSObjection createInjector:providerModule];
    [JSObjection setDefaultInjector:injector];      
  });
  
  it(@"allows a bound protocol to be created through a provider", ^{
    FiveSpeedCar *car = [[JSObjection defaultInjector] getObject:[Car class]];
    
    assertThat(car, is(instanceOf([FiveSpeedCar class])));
    assertThat(car.brakes, is(instanceOf([Brakes class])));
    assertThat(car.engine, is(@"my engine"));
  });
  
  it(@"allows a bound class to be created through a provider", ^{
    AfterMarketGearBox *gearBox = [[JSObjection defaultInjector] getObject:@protocol(GearBox)];      
    assertThat(gearBox, is(instanceOf([AfterMarketGearBox class])));
  });
});

describe(@"block bindings", ^{
  __block BlockModule *blockModule = nil;
  
  beforeEach(^{
    blockModule = [[BlockModule alloc] init];    
    JSObjectionInjector *injector = [JSObjection createInjector:blockModule];
    [JSObjection setDefaultInjector:injector];      
  });
  
  it(@"allows a bound protocol to be created using a block", ^{
    FiveSpeedCar *car = [[JSObjection defaultInjector] getObject:[Car class]];
    
    assertThat(car, is(instanceOf([FiveSpeedCar class])));
    assertThat(car.brakes, is(instanceOf([Brakes class])));
    assertThat(car.engine, is(@"My Engine"));      
  });
  
  it(@"allows a bound class to be created using a block", ^{
    AfterMarketGearBox *gearBox = [[JSObjection defaultInjector] getObject:@protocol(GearBox)];      
    assertThat(gearBox, is(instanceOf([AfterMarketGearBox class])));
  });
});

describe(@"block bindings properties nil", ^{
    __block BlockModule *blockModule = nil;
    
    beforeEach(^{
        blockModule = [[BlockModule alloc] init];
        blockModule.instrumentNilBlock = YES;
        JSObjectionInjector *injector = [JSObjection createInjector:blockModule];
        [JSObjection setDefaultInjector:injector];
    });
    
    it(@"allows a returned nil value from bindBlock", ^{
        // attempt to inject dependencies into Car via InjectDependenciesIntoProperties
        // ensure that Car is successfully injected and property brakes
        // returned from bindBlock is set as nil on Car if that was the intention
        Car *car = [[JSObjection defaultInjector] getObject:[Car class]];
        assertThat(car, notNilValue());
        assertThat(car, is(instanceOf([SixSpeedCar class])));
        assertThat(car.brakes, nilValue());
    });
});

describe(@"meta class bindings", ^{
  it(@"supports binding to a meta class instance via a protocol", ^{
    id<MetaCar> car = [[JSObjection defaultInjector] getObject:@protocol(MetaCar)];
    assertThat(car, is([Car class]));    
    assertThat([car manufacture], is(instanceOf([Car class])));
  });
  
  it(@"throws an exception if the given object is not a meta class", ^{
    id<GearBox> gearBox = [[AfterMarketGearBox alloc] init];
    Engine *engine = [[Engine alloc] init];

    [[theBlock(^{
      MyModule *module = [[MyModule alloc] initWithEngine:engine andGearBox:gearBox];    
      module.instrumentInvalidMetaClass = YES;
      [module configure];
    }) should] raiseWithReason:@"\"sneaky\" can not be bound to the protocol \"MetaCar\" because it is not a meta class"];
  });
  
});

describe(@"class to protocol bindings", ^{
  it(@"supports associating a concrete class with a protocol", ^{
    VisaCCProcessor *processor = [[JSObjection defaultInjector] getObject:@protocol(CreditCardProcessor)];
    
    assertThat(processor, is(instanceOf([VisaCCProcessor class])));
    assertThat(processor.validator, is(instanceOf([CreditCardValidator class])));
  });
});

describe(@"subclass to superclass bindings", ^{
  it(@"supports associating a concrete class with a protocol", ^{
    VisaCCProcessor *processor = [[JSObjection defaultInjector] getObjectWithArgs:[BaseCreditCardProcessor class], @"12414", nil];
    
    assertThat(processor, is(instanceOf([VisaCCProcessor class])));
    assertThat(processor.validator, is(instanceOf([CreditCardValidator class])));
    assertThat(processor.CCNumber, equalTo(@"12414"));
  });  
});

describe(@"multiple modules", ^{
    beforeEach(^{
      FirstModule *first = [[FirstModule alloc] init];
      SecondModule *second = [[SecondModule alloc] init]; 
      JSObjectionInjector *injector = [JSObjection createInjectorWithModules:first, second, nil];
      [JSObjection setDefaultInjector:injector];
    });
  
    it(@"merges the binding in each module", ^{
      AfterMarketGearBox *gearBox = [[JSObjection defaultInjector] getObject:@protocol(GearBox)];      
      Car *car = [[JSObjection defaultInjector] getObject:[Car class]];
      
      assertThat(gearBox, is(instanceOf([AfterMarketGearBox class])));
      assertThat(car, is(instanceOf([FiveSpeedCar class])));
      assertThatBool(gEagerSingletonHook, equalToBool(YES));
    });
});

describe(@"scopes", ^{
    __block ScopeModule *scopeModule = nil;
    __block JSObjectionInjector *injector = nil;
    
    beforeEach(^{
        scopeModule = [[ScopeModule alloc] init];
        injector = [JSObjection createInjector:scopeModule];
    });
    
    it(@"can bind a class in singleton scope", ^{
        assertThat(injector[[Car class]], is(sameInstance(injector[[Car class]])));
    });
    
    it(@"can bind a class in a normal scope", ^{
        assertThat(injector[[VisaCCProcessor class]], isNot(sameInstance(injector[[VisaCCProcessor class]])));
    });
});

describe(@"has binding", ^{
    __block FirstModule *firstModule = nil;
    __block SecondModule *secondModule = nil;

    beforeEach(^{
      firstModule = [[FirstModule alloc] init];
      secondModule = [[SecondModule alloc] init];
      [firstModule configure];
      [secondModule configure];
    });

  it(@"returns correct value for hasBindingForClass:", ^{
    assertThatBool([firstModule hasBindingForClass:[Car class]], equalToBool(YES));
    assertThatBool([firstModule hasBindingForClass:[UnregisteredCar class]], equalToBool(NO));
  });

  it(@"returns correct value for hasBindingForProtocol", ^{
    assertThatBool([secondModule hasBindingForProtocol:@protocol(GearBox)], equalToBool(YES));
    assertThatBool([secondModule hasBindingForProtocol:@protocol(UnregisteredProtocol)], equalToBool(NO));
  });
});

SPEC_END
