#import "ModuleFixtures.h"

BOOL gEagerSingletonHook = NO;

@implementation Car(Meta)

+ (id)manufacture {
  return [[Car alloc] init];
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
@synthesize engine = _engine;
@synthesize gearBox = _gearBox;
@synthesize instrumentInvalidEagerSingleton=_instrumentInvalidEagerSingleton;
@synthesize instrumentInvalidMetaClass = _instrumentInvalidMetaClass;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox {
  if ((self = [super init])) {
    _engine = engine;
    _gearBox = gearBox;
  }

  return self;
}

- (void)configure {
    [self bind:_engine toClass:[Engine class]];
    [self bind:_gearBox toProtocol:@protocol(GearBox)];
    [self bindClass:[VisaCCProcessor class] toProtocol:@protocol(CreditCardProcessor)];
    [self bindClass:[VisaCCProcessor class] toClass:[BaseCreditCardProcessor class]];
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


@end

@implementation CarProvider
- (id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments
{
    Car *car = [context getObject:[FiveSpeedCar class]];
    car.engine = (id)@"my engine";
    return car;
}
@end

@implementation GearBoxProvider
- (id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments
{
    return [[AfterMarketGearBox alloc] init];
}
@end


@implementation ProviderModule
- (void)configure
{
    [self bindProvider:[[CarProvider alloc] init] toClass:[Car class]];
    [self bindProvider:[[GearBoxProvider alloc] init] toProtocol:@protocol(GearBox)];
}
@end

@implementation BlockModule

- (void)configure
{
    NSString *myEngine = @"My Engine";
    Brakes *myBrakes = [[Brakes alloc] init];

    [self bindBlock:^(JSObjectionInjector *context) {
        if (_instrumentNilBlock) {
            return (id)nil;
        }

        return (id)myBrakes;
    } toClass:[Brakes class]];

    [self bindBlock:^(JSObjectionInjector *context) {
        Car *car = nil;
        if (_instrumentNilBlock) {
            car = [context getObject:[SixSpeedCar class]];
        }
        else {
            car = [context getObject:[FiveSpeedCar class]];
            car.engine = (id)myEngine;
        }
        return (id)car;
    } toClass:[Car class]];

    AfterMarketGearBox *gearBox = [[AfterMarketGearBox alloc] init];
    [self bindBlock:^(JSObjectionInjector *context) {
        return (id)gearBox;
    } toProtocol:@protocol(GearBox)];
}

@end

@implementation BaseCreditCardProcessor
- (void)processNumber:(NSString *)number {

}
@end

@implementation CreditCardValidator
@end

@implementation VisaCCProcessor
objection_register_singleton(VisaCCProcessor)
objection_initializer(initWithCreditCardNumber:, @"Default")
objection_requires(@"validator")

@synthesize validator = _validator;
@synthesize CCNumber;

- (id)initWithCreditCardNumber:(NSString *)aCCNumber {
    if ((self = [super init])) {
        self.CCNumber = aCCNumber;
    }
    return self;
}
- (void)processNumber:(NSString *)number {
    [super processNumber:number];
}

@end


@implementation FirstModule
- (void)configure {
    [self bind:[[FiveSpeedCar alloc] init] toClass:[Car class]];
    [self registerEagerSingleton:[EagerSingleton class]];
}
@end

@implementation SecondModule
- (void)configure {
    [self bind:[[AfterMarketGearBox alloc] init] toProtocol:@protocol(GearBox)];
}
@end

@implementation ScopeModule

- (void)configure {
    [self bindClass:[VisaCCProcessor class] inScope:JSObjectionScopeNormal];
    [self bindClass:[Car class] inScope:JSObjectionScopeSingleton];
    [self registerEagerSingleton:[Car class]];
}
@end

@implementation BlockScopeModule

- (void)configure {
    [self bindBlock:^(JSObjectionInjector *context) {
        Car *car = [[Car alloc] init];
        return (id)car;
    } toClass:[Car class] inScope:JSObjectionScopeSingleton];

    [self bindBlock:^(JSObjectionInjector *context) {
        return [[AfterMarketGearBox alloc] init];
    } toProtocol:@protocol(GearBox) inScope:JSObjectionScopeNormal];
}

@end

@implementation ProviderScopeModule
- (void)configure
{
    [self bindProvider:[[CarProvider alloc] init] toClass:[Car class] inScope:JSObjectionScopeSingleton];
    [self bindProvider:[[GearBoxProvider alloc] init] toProtocol:@protocol(GearBox) inScope:JSObjectionScopeNormal];
}
@end

@implementation BlinkerProvider

-(id)provide:(JSObjectionInjector *)context arguments:(NSArray *)arguments {
    Blinker *blinker = [[Blinker alloc]init];
    blinker.speed = @11;
    return (id<Blinkable>)blinker;
}

@end

@implementation NamedModule
{
    Headlight* _rightHeadlight;
}

- (void)configure
{
    [self bind:_rightHeadlight toClass:[Headlight class] named:@"RightHeadlight"];
    [self bindClass:[HIDHeadlight class] toClass:[Headlight class] named:@"LeftHeadlight"];
    [self bindProvider:[[BlinkerProvider alloc]init] toProtocol:@protocol(Blinkable) named:@"RightBlinker"];
    [self bindBlock:^(JSObjectionInjector *context){
        Blinker *blinker = [[Blinker alloc]init];
        blinker.speed = @1.092;
        return (id<Blinkable>)blinker;
    } toProtocol:@protocol(Blinkable) named:@"LeftBlinker"];

    [self bindClass:[HIDHeadlight class] toClass:[Headlight class] inScope:JSObjectionScopeSingleton named:@"My HID Headlight" ];
}

-(id)initWithRightHeadlight:(Headlight *)rightHeadlight {
    self = [super init];
    if (self) {
        _rightHeadlight = rightHeadlight;
    }
    return self;
}

@end