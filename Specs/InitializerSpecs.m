#import "SpecHelper.h"
#import "InitializerFixtures.h"

QuickSpecBegin(InitializerSpecs)
__block JSObjectionInjector *injector = nil;

beforeEach(^{
    injector = [JSObjection createInjector];
});

it(@"instantiates the object with the default initializer arguments", ^{
    ViewController *controller = [injector getObject:[ViewController class]];
    
    expect(controller.nibName).to(equal(@"MyNib"));
    expect(controller.bundle).to(beNil());
    expect(controller.car).to(beAKindOf([Car class]));
});

it(@"will override the default arguments if arguments are passed to the injector", ^{
    ViewController *controller = [injector getObjectWithArgs:[ViewController class], @"AnotherNib", @"pretendBundle", nil];

    expect(controller.nibName).to(equal(@"AnotherNib"));
    expect(controller.bundle).to(equal(@"pretendBundle"));
    expect(controller.car).to(beAKindOf([Car class]));
});

it(@"is OK to register an object with an initializer without any default arguments", ^{
    ConfigurableCar *car = [injector getObjectWithArgs:[ConfigurableCar class], @"Passat", [NSNumber numberWithInt:200], [NSNumber numberWithInt:2002], nil];
    
    expect(car.horsePower).to(equal(@200));
    expect(car.model).to(equal(@"Passat"));
    expect(car.year).to(equal(@2002));
    expect(car.engine).to(beAKindOf([Engine class]));
});

it(@"raises an exception if the initializer is not valid", ^{
    expect([injector getObject:[BadInitializer class]]).to(raiseException().reason(@"Could not find initializer 'initWithNonExistentInitializer' on BadInitializer"));
});

it(@"injector supports passing a different initializer", ^{
    ViewController *controller = [injector getObject:[ViewController class] initializer:@selector(initWithName:) argumentList:@[@"The Name"]];
    expect(controller.name).to(equal(@"The Name"));
    
    controller = [injector getObject:[ViewController class] initializer:@selector(initWithName:) argumentList:@[]];
    expect(controller.name).to(beNil());
});


it(@"supports initializing an object with a class method", ^{
    Truck *truck = [injector getObjectWithArgs:[Truck class], @"Ford", nil];

    expect(truck).toNot(beNil());
    expect(truck.name).to(equal(@"Ford"));
});

it(@"filters the init initializer as a class initializer option", ^{
    FilterInitInitializer *obj = [injector getObject:[FilterInitInitializer class]];
    expect(obj).toNot(beNil());
});

QuickSpecEnd