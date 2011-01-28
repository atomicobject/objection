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



@interface MyModule : ObjectionModule
{
  Engine *_engine;
  id<GearBox> _gearBox;
}

@property(nonatomic, readonly) Engine *engine;
@property(nonatomic, readonly) id<GearBox> gearBox;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox;
@end

@implementation MyModule
@synthesize engine=_engine;
@synthesize gearBox=_gearBox;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox {
  if (self = [super init]) {
    _engine = [engine retain];
    _gearBox = [gearBox retain];
  }
  
  return self;
}

- (void)configure {
  [self bind:_engine toClass:[Engine class]];
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
    Car *car = [[Objection globalInjector] getObject:[Car class]];
    
    assertThat(car.engine, is(sameInstance(module.engine)));    
  });

  it(@"supports binding an instance to a protocol", ^{
    MyModule *module = GetFromContext(@"module");
    assertThat([[Objection globalInjector] getObject:@protocol(GearBox)], is(sameInstance(module.gearBox)));    
  });

//  it(@"throws an exception of the instance does not conform the protocol", ^{
//    Engine *engine = [[[Engine alloc] init] autorelease];
//    
//    assertRaises(^{
//      [[[MyModule alloc] initWithEngine:engine andGearBox:(id)@"no go"] autorelease];    
//    }, @"That hurts!") ; 
//  });

SPEC_END
