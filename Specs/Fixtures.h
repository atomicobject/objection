#import <Foundation/Foundation.h>

@interface Engine : NSObject
{
  BOOL awake;  
}
@property(nonatomic) BOOL awake;

@end

@interface Brakes : NSObject
{
  
}
@end


@interface Car : NSObject
{
  Engine *engine;
  Brakes *brakes;
  BOOL awake; 
}

@property(nonatomic, strong) Engine *engine;
@property(nonatomic, strong) Brakes *brakes;
@property(nonatomic) BOOL awake;

@end

@interface UnregisteredCar : NSObject
@property(nonatomic, strong) Engine *engine;
@end

@protocol UnregisteredProtocol
@end

@protocol GearBox;

@protocol ManualCar <NSObject>
@property (nonatomic, retain) id<GearBox> gearBox;
@end

@interface FiveSpeedCar : Car<ManualCar>
@end

@interface SixSpeedCar : Car<ManualCar>
@end

@interface CarFactory : NSObject
{
  
}

@end

@interface SingletonItem : NSObject
{
  
}
@end


@interface SingletonItemHolder : NSObject
{
  SingletonItem *singletonItem;
}

@property(nonatomic, strong) SingletonItem *singletonItem;
@end

@class JSObjectFactory;

@interface JSObjectFactoryHolder : NSObject
@property (nonatomic, strong) JSObjectFactory *objectFactory;
@end

@class SingletonBar;

@interface SingletonFoo : NSObject
{
  SingletonBar *bar;
}
@property(nonatomic, strong) SingletonBar *bar;

@end

@interface UnstoppableCar : NSObject
@property(nonatomic, strong) Engine *engine;
@end
