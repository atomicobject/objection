#import "InitializerFixtures.h"
#import "ModuleFixtures.h"

@implementation BadInitializer
objection_register(BadInitializer)
objection_initializer(initWithNonExistentInitializer)
@end

@implementation ViewController
objection_register(ViewController)
objection_requires(@"car")
objection_initializer(initWithNibName:bundle:, @"MyNib")

@synthesize car = _car;
@synthesize nibName = _nibName;
@synthesize bundle = _bundle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super init])) {
        self.nibName = nibNameOrNil;
        self.bundle = nibBundleOrNil;
    }
    return self;
}

- (void)dealloc {
    [_nibName release];
    [_car release];
    [super dealloc];
}
@end

@implementation ConfigurableCar
objection_register(ConfigurableCar)
objection_requires(@"engine")
objection_initializer(initWithModel:horsePower:andYear:)

@synthesize car = _car;
@synthesize engine = _engine;

@synthesize horsePower = _horsePower;
@synthesize model = _model;
@synthesize year = _year;

- (id)initWithModel:(NSString *)model horsePower:(NSNumber *)horsePower andYear:(NSNumber *)year {
    if ((self = [super init])) {
        self.model = model;
        self.horsePower = horsePower;
        self.year = year;
    }
    return self;
}

- (void)dealloc {
    [_model release];
    [_horsePower release];
    [_year release];
    [super dealloc];
}
@end

@interface CarWithInitializerDependencies ()
@property(readwrite, nonatomic, retain) Engine *engine;
@property(readwrite, nonatomic, retain) NSObject <GearBox> *gearBox;

@end

@implementation CarWithInitializerDependencies
{
}
@synthesize gearBox = _gearBox;
@synthesize engine = _engine;
objection_register(CarWithInitializerDependencies)
objection_initializer(initWithEngine:gearBox:, classDependency(Engine), [AfterMarketGearBox new])

- (id)initWithEngine:(Engine *)engine gearBox:(NSObject <GearBox>*)gearBox
{
    self = [super init];
    if (self)
    {
        self.engine = engine;
        self.gearBox = gearBox;
    }
    return self;
}

- (BOOL)hasEngine { return _engine != nil;}

- (void)dealloc
{
    [_engine release];
    [_gearBox release];
    [super dealloc];
}

@end