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
}

@end