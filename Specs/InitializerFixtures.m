#import "InitializerFixtures.h"

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

@end

@implementation ConfigurableCar
objection_register(ConfigurableCar)
objection_requires(@"engine")
objection_initializer_sel(@selector(initWithModel:horsePower:andYear:))

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

@end