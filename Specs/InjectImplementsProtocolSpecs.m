#import "SpecHelper.h"
#import "Fixtures.h"
#import "ModuleFixtures.h"

@interface RocketEngine : Engine <UnregisteredProtocol, Blinkable>
@end

@implementation RocketEngine
@synthesize speed;
@end

@interface RocketScienceModule : JSObjectionModule
@end

@implementation RocketScienceModule
-(void)configure {
    [self bindClass:[RocketEngine class] toClass:[Engine class]];
}
@end

@interface ExperimentalCar : NSObject
@property (nonatomic, retain) Engine<UnregisteredProtocol, Blinkable> *engine;
@end

@implementation ExperimentalCar
objection_requires(@"engine")
@end

QuickSpecBegin(InjectImplementsProtocolSpecs)

__block JSObjectionInjector *injector = nil;
__block ExperimentalCar *carWithRocketEngine = nil;

beforeEach(^{
    injector = [JSObjection createInjector:[RocketScienceModule new]];
    carWithRocketEngine = [ExperimentalCar new];
});

it(@"injects property engine that implements Blinkable and UnregisteredProtocol protocols ", ^{
    [injector injectDependencies:carWithRocketEngine];
    assertThat(carWithRocketEngine.engine, is(instanceOf([RocketEngine class])));
});

QuickSpecEnd