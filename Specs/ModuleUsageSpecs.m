#import "SpecHelper.h"
#import "Fixtures.h"

@protocol GearBox<NSObject>
- (void)shiftUp;
- (void)shiftDown;
@optional // ;-)
- (void)engageClutch;
@end

@interface WantsToBreakGearBox : NSObject<GearBox>
@end

@implementation WantsToBreakGearBox
- (void)shiftUp {
  
}

- (void)shiftDown {
  
}
@end

static BOOL gEagerSingletonHook = NO;
@interface EagerSingleton : NSObject

@end

@implementation EagerSingleton
objection_register_singleton(EagerSingleton)
- (void)awakeFromObjection {
  gEagerSingletonHook = YES;
}
@end




@interface MyModule : ObjectionModule
{
  Engine *_engine;
  id<GearBox> _gearBox;
  BOOL _instrumentInvalidEagerSingleton;
}

@property(nonatomic, readonly) Engine *engine;
@property(nonatomic, readonly) id<GearBox> gearBox;
@property(nonatomic, assign) BOOL instrumentInvalidEagerSingleton;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox;
@end

@implementation MyModule
@synthesize engine=_engine;
@synthesize gearBox=_gearBox;
@synthesize instrumentInvalidEagerSingleton=_instrumentInvalidEagerSingleton;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox {
  if (self = [super init]) {
    _engine = [engine retain];
    _gearBox = [gearBox retain];
  }
  
  return self;
}

- (void)configure {
  [self bind:_engine toClass:[Engine class]];
  [self bind:_gearBox toProtocol:@protocol(GearBox)];
  if (_instrumentInvalidEagerSingleton) {
    [self registerEagerSingleton:[Car class]];
  } else {
    [self registerEagerSingleton:[EagerSingleton class]];
  }

}

- (void)dealloc {
  [_engine release];_engine = nil;
  [_gearBox release];_gearBox = nil;
  [super dealloc];
}

@end


SPEC_BEGIN(ModuleUsageSpecs)

  beforeEach(^{
    Engine *engine = [[[Engine alloc] init] autorelease];
    id<GearBox> gearBox = [[[WantsToBreakGearBox alloc] init] autorelease];
    
    MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:gearBox] autorelease];    
    AddToContext(@"module", module);
    ObjectionInjector *injector = [Objection createInjector:module];
    [Objection setGlobalInjector:injector];
  });

  it(@"merges the modules instance binding with the injector's context", ^{
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

  it(@"throws an exception of the instance does not conform the protocol", ^{
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
      id<GearBox> gearBox = [[[WantsToBreakGearBox alloc] init] autorelease];
      MyModule *module = [[[MyModule alloc] initWithEngine:engine andGearBox:gearBox] autorelease];    
      module.instrumentInvalidEagerSingleton = YES;
      [Objection createInjector:module];
    }, @"Unable to initialize eager singleton for the class 'Car' because it was never registered as a singleton") ;     
  });

SPEC_END
