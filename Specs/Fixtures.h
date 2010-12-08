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

@property(nonatomic, retain) Engine *engine;
@property(nonatomic, retain) Brakes *brakes;
@property(nonatomic) BOOL awake;

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

@property(nonatomic, retain) SingletonItem *singletonItem;
@end

