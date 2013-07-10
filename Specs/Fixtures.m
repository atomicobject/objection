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
