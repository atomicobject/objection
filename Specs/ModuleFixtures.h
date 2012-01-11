#import <Foundation/Foundation.h>
#import "Fixtures.h"
#import "SpecHelper.h"

extern BOOL gEagerSingletonHook;

@protocol MetaCar<NSObject>
- (id)manufacture;
@end

@protocol GearBox<NSObject>
- (void)shiftUp;
- (void)shiftDown;
@optional // ;-)
- (void)engageClutch;
@end


@interface Car(Meta)
// Perfect example of why factories are OK alternatives to class methods. 
// Car that manufactures a...car?
+ (id)manufacture;
@end


@interface AfterMarketGearBox : NSObject<GearBox>
@end

@interface EagerSingleton : NSObject
@end

@interface MyModule : JSObjectionModule
{
  Engine *_engine;
  id<GearBox> _gearBox;
  BOOL _instrumentInvalidEagerSingleton;
  BOOL _instrumentInvalidMetaClass;
}

@property(nonatomic, readonly) Engine *engine;
@property(nonatomic, readonly) id<GearBox> gearBox;
@property(nonatomic, assign) BOOL instrumentInvalidEagerSingleton;
@property (nonatomic, assign) BOOL instrumentInvalidMetaClass;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox;
@end

@interface CarProvider : NSObject<JSObjectionProvider>
@end

@interface GearBoxProvider : NSObject<JSObjectionProvider>
@end

@interface ProviderModule : JSObjectionModule
@end

@interface BlockModule : JSObjectionModule
@end

@interface CreditCardValidator : NSObject
@end

@protocol CreditCardProcessor <NSObject>
- (void)processNumber:(NSString *)number;
@end

@interface BaseCreditCardProcessor : NSObject<CreditCardProcessor>
@end

@interface VisaCCProcessor : BaseCreditCardProcessor<CreditCardProcessor> {
  CreditCardValidator *_validator;
}
@property (nonatomic, retain) CreditCardValidator *validator;
@end

@interface FirstModule : JSObjectionModule
@end

@interface SecondModule : JSObjectionModule
@end






