#import "Fixtures.h"
#import "Objection.h"

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

@implementation ManualCar
objection_register(ManualCar)

@synthesize gearBox;

objection_requires(@"gearBox")
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

