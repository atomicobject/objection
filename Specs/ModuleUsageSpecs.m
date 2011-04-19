#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"

SPEC_BEGIN(ModuleUsageSpecs)

  beforeEach(^{
    Engine *engine = [[[Engine alloc] init] autorelease];
    id<GearBox> gearBox = [[[AfterMarketGearBox alloc] init] autorelease];
    
    MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:gearBox] autorelease];    
    AddToContext(@"module", module);
    ObjectionInjector *injector = [Objection createInjector:module];
    [Objection setGlobalInjector:injector];
  });

  it(@"merges the modules instance bindings with the injector's context", ^{
    MyModule *module = GetFromContext(@"module");
    assertThat([[Objection globalInjector] getObject:[Engine class]], is(sameInstance(module.engine)));
  });

  it(@"uses the module's bounded instance to fill out other objects dependencies", ^{
    MyModule *module = GetFromContext(@"module");
    ManualCar *car = [[Objection globalInjector] getObject:[ManualCar class]];
    
    assertThat(car.engine, is(sameInstance(module.engine)));    
    assertThat(car.gearBox, is(sameInstance(module.gearBox)));    
  });

  it(@"supports binding an instance to a protocol", ^{
    MyModule *module = GetFromContext(@"module");
    assertThat([[Objection globalInjector] getObject:@protocol(GearBox)], is(sameInstance(module.gearBox)));    
  });

  it(@"throws an exception if the instance does not conform to the protocol", ^{
    Engine *engine = [[[Engine alloc] init] autorelease];
    
    assertRaises(^{
      MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:(id)@"no go"] autorelease];    
      [module configure];
    }, @"Instance does not conform to the GearBox protocol") ; 
  });

  it(@"supports eager singletons", ^{
    assertThatBool(gEagerSingletonHook, equalToBool(YES));
  });

  it(@"throws an exception if an attempt is made to register an eager singleton that was not registered as a singleton", ^{
    Engine *engine = [[[Engine alloc] init] autorelease];
    
    assertRaises(^{
      id<GearBox> gearBox = [[[AfterMarketGearBox alloc] init] autorelease];
      MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:gearBox] autorelease];    
      module.instrumentInvalidEagerSingleton = YES;
      [Objection createInjector:module];
    }, @"Unable to initialize eager singleton for the class 'Car' because it was never registered as a singleton") ;     
  });

  describe(@"provider bindings", ^{
    beforeEach(^{
      MyModule *module = [[[ProviderModule alloc] init] autorelease];    
      AddToContext(@"module", module);
      ObjectionInjector *injector = [Objection createInjector:module];
      [Objection setGlobalInjector:injector];      
    });
    
    it(@"allows a bound protocol to be created through a provider", ^{
      ManualCar *car = [[Objection globalInjector] getObject:[Car class]];
      
      assertThat(car, is(instanceOf([ManualCar class])));
      assertThat(car.brakes, is(instanceOf([Brakes class])));
      assertThat(car.engine, is(@"my engine"));
    });
    
    it(@"allows a bound class to be created through a provider", ^{
      AfterMarketGearBox *gearBox = [[Objection globalInjector] getObject:@protocol(GearBox)];      
      assertThat(gearBox, is(instanceOf([AfterMarketGearBox class])));
    });
  });

  describe(@"block bindings", ^{
    beforeEach(^{
      MyModule *module = [[[BlockModule alloc] init] autorelease];    
      AddToContext(@"module", module);
      ObjectionInjector *injector = [Objection createInjector:module];
      [Objection setGlobalInjector:injector];      
    });
    
    it(@"allows a bound protocol to be created using a block", ^{
      ManualCar *car = [[Objection globalInjector] getObject:[Car class]];
      
      assertThat(car, is(instanceOf([ManualCar class])));
      assertThat(car.brakes, is(instanceOf([Brakes class])));
      assertThat(car.engine, is(@"My Engine"));      
    });
    
    it(@"allows a bound class to be created using a block", ^{
      AfterMarketGearBox *gearBox = [[Objection globalInjector] getObject:@protocol(GearBox)];      
      assertThat(gearBox, is(instanceOf([AfterMarketGearBox class])));
    });    
  });

  describe(@"meta class bindings", ^{
    it(@"supports binding to a meta class instance via a protocol", ^{
      id<MetaCar> car = [[Objection globalInjector] getObject:@protocol(MetaCar)];
      assertThat(car, is([Car class]));    
      assertThat([car manufacture], is(instanceOf([Car class])));
    });
    
    it(@"throws an exception if the given object is not a meta class", ^{
      id<GearBox> gearBox = [[[AfterMarketGearBox alloc] init] autorelease];
      Engine *engine = [[[Engine alloc] init] autorelease];

      assertRaises(^{
        MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:gearBox] autorelease];    
        module.instrumentInvalidMetaClass = YES;
        [module configure];
      }, @"\"sneaky\" can not be bound to the protocol \"MetaCar\" because it is not a meta class");       
    });
  });



SPEC_END
