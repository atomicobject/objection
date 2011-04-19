#import "ModuleFixtures.h"

BOOL gEagerSingletonHook = NO;

@implementation Car(Meta)

+ (id)manufacture {
  return [[[Car alloc] init] autorelease];
}

@end


@implementation AfterMarketGearBox
- (void)shiftUp {
  
}

- (void)shiftDown {
  
}
@end

@implementation EagerSingleton
objection_register_singleton(EagerSingleton)
- (void)awakeFromObjection {
  gEagerSingletonHook = YES;
}
@end


@implementation MyModule
@synthesize engine=_engine;
@synthesize gearBox=_gearBox;
@synthesize instrumentInvalidEagerSingleton=_instrumentInvalidEagerSingleton;
@synthesize instrumentInvalidMetaClass = _instrumentInvalidMetaClass;

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
  
  if (self.instrumentInvalidMetaClass) {
    [self bindMetaClass:(id)@"sneaky" toProtocol:@protocol(MetaCar)];
  } else {
    [self bindMetaClass:[Car class] toProtocol:@protocol(MetaCar)];    
  }
  
  if (self.instrumentInvalidEagerSingleton) {
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

@implementation CarProvider
- (id)createInstance:(ObjectionInjector *)context
{
  Car *car = [context getObject:[ManualCar class]];
  car.engine = (id)@"my engine";
  return car;
}
@end

@implementation GearBoxProvider
- (id)createInstance:(ObjectionInjector *)context
{
  return [[[AfterMarketGearBox alloc] init] autorelease];
}
@end


@implementation ProviderModule
- (void)configure
{
  [self bindProvider:[[[CarProvider alloc] init] autorelease] toClass:[Car class]];
  [self bindProvider:[[[GearBoxProvider alloc] init] autorelease] toProtocol:@protocol(GearBox)];
}
@end

@implementation BlockModule

- (void)configure
{
  NSString *myEngine = [NSString stringWithString:@"My Engine"];
  
  [self bindBlock:^(ObjectionInjector *context) {
    Car *car = [context getObject:[ManualCar class]];
    car.engine = (id)myEngine;
    return (id)car;    
  } toClass:[Car class]];
  
  AfterMarketGearBox *gearBox = [[[AfterMarketGearBox alloc] init] autorelease];
  [self bindBlock:^(ObjectionInjector *context) {
    return (id)gearBox;
  } toProtocol:@protocol(GearBox)];
}

@end
