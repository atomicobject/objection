#import "Fixtures.h"
#import "Objection.h"
#import "CircularDependencyFixtures.h"

@implementation Engine
objection_register(Engine)
@synthesize awake;

- (void) awakeFromObjection {
	awake = YES;  
}
@end

@implementation Brakes

@end


@implementation Car
objection_register(Car)

@synthesize engine, brakes, awake;

- (void)awakeFromObjection {
  awake = YES;
}

objection_requires(@"engine", @"brakes")
@end

@implementation UnregisteredCar
objection_requires(@"engine")
@synthesize engine;
@end

@implementation FiveSpeedCar
objection_register(FiveSpeedCar)

@synthesize gearBox;

objection_requires(@"gearBox")
@end

@implementation SixSpeedCar
objection_register(SixSpeedCar)
@synthesize gearBox;
@end

@implementation CarFactory
objection_register_singleton(CarFactory)
@end

@implementation SingletonItemHolder
@synthesize singletonItem;
objection_register(SingletonItemHolder)
objection_requires(@"singletonItem")
@end

@implementation SingletonItem
objection_register_singleton(SingletonItem)
@end

@implementation JSObjectFactoryHolder
objection_register_singleton(JSObjectFactoryHolder)
objection_requires(@"objectFactory")

@synthesize objectFactory;
@end

@implementation SingletonFoo
objection_register_singleton(SingletonFoo)
objection_requires(@"bar")

@synthesize bar;
@end

@implementation UnstoppableCar
objection_requires_sel(@selector(engine))
@end

@implementation Headlight
objection_register(Headlight)
@end

@implementation HIDHeadlight
objection_register(HIDHeadlight)
@end

@implementation ShinyCar
objection_register(ShinyCar)
objection_requires_names((@{@"LeftHeadlight":@"leftHeadlight", @"RightHeadlight":@"rightHeadlight"}))
objection_requires(@"foglight")
@synthesize leftHeadlight, rightHeadlight, foglight;
@end

@implementation Blinker
objection_register(Blinker)
@synthesize speed;
@end

@implementation FlashyCar
objection_register(FlashyCar)
objection_requires_names((@{ @"LeftBlinker":@"leftBlinker",@"RightBlinker":@"rightBlinker"}))
@synthesize leftBlinker, rightBlinker;
@end

@implementation Highbeam
objection_register_singleton(Highbeam)
@end

@implementation BrightCar
objection_register(BrightCar)
objection_requires_names((@{ @"LeftHighbeam":@"leftHighbeam",@"RightHighbeam":@"rightHighbeam"}))
@synthesize leftHighbeam, rightHighbeam;
@end
