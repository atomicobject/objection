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
@optional
- (void)engageClutch;
@end


@interface Car(Meta)
+ (id)manufacture;
@end


@interface AfterMarketGearBox : NSObject<GearBox>
@end

@interface EagerSingleton : NSObject
@end

@interface MyModule : JSObjectionModule
{
  BOOL _instrumentInvalidEagerSingleton;
  BOOL _instrumentInvalidMetaClass;
}

@property(weak, nonatomic, readonly) Engine *engine;
@property(weak, nonatomic, readonly) id<GearBox> gearBox;
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

@property (nonatomic, assign) BOOL instrumentNilBlock;

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
- (id)initWithCreditCardNumber:(NSString *)aCCNumber;
@property (nonatomic, strong) NSString *CCNumber;
@property (nonatomic, strong) CreditCardValidator *validator;
@end

@interface FirstModule : JSObjectionModule
@end

@interface SecondModule : JSObjectionModule
@end

@interface ScopeModule : JSObjectionModule

@end

@interface BlockScopeModule : JSObjectionModule

@end

@interface ProviderScopeModule : JSObjectionModule

@end

@interface BlinkerProvider : NSObject<JSObjectionProvider>
@end

@interface NamedModule : JSObjectionModule
- (id)initWithRightHeadlight:(Headlight*)rightHeadlight;
@end




