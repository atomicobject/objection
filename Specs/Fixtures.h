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

@interface Headlight : NSObject
@end

@interface HIDHeadlight : Headlight
@end

@interface ShinyCar : NSObject
@property (nonatomic, strong) Headlight *leftHeadlight;
@property (nonatomic, strong) Headlight *rightHeadlight;
@property (nonatomic, strong) Headlight *foglight;
@end

@protocol Blinkable
@property (nonatomic, strong) NSNumber* speed;
@end

@interface Blinker : NSObject<Blinkable>
@property (nonatomic, strong) NSNumber* speed;
@end

@interface FlashyCar : NSObject
@property (nonatomic, strong) id<Blinkable> leftBlinker;
@property (nonatomic, strong) id<Blinkable> rightBlinker;
@end

@interface Highbeam : NSObject
@end

@interface BrightCar : NSObject
@property (nonatomic, strong) Highbeam *leftHighbeam;
@property (nonatomic, strong) Highbeam *rightHighbeam;
@end
