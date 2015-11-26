#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"

@interface NewCarModule : JSObjectionModule
@end

@implementation NewCarModule
-(void)configure {
    [self bindClass:[UnregisteredCar class] toClass:[Car class]];
}
@end

@interface CarOwner : NSObject
@property (nonatomic, strong) Car<UnregisteredProtocol> *car;
@end

@implementation CarOwner
objection_requires(@"car")
@end

QuickSpecBegin(InjectImplementsProtocolSpecs)

__block JSObjectionInjector *injector = nil;
__block CarOwner *carDriver = nil;

beforeEach(^{
    injector = [JSObjection createInjector:[NewCarModule new]];
    carDriver = [CarOwner new];
});

it(@"injects property car that implements UnregisteredProtocol", ^{
    [injector injectDependencies:carDriver];
    assertThat(carDriver.car, is(instanceOf([UnregisteredCar class])));
});

QuickSpecEnd