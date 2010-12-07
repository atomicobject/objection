#import "SpecHelper.h"
#import "Fixtures.h"

@interface MyModule : ObjectionModule
{
  Engine *_engine;
}

@property(nonatomic, readonly) Engine *engine;

- (id)initWithEngine:(Engine *)engine;
@end

@implementation MyModule
@synthesize engine=_engine;

- (id)initWithEngine:(Engine *)engine {
  if (self = [super init]) {
    _engine = [engine retain];
  }
  
  return self;
}

- (void)configure {
  [self bind:_engine toClass:[Engine class]];
}

- (void)dealloc {
  [_engine release];_engine = nil;
  [super dealloc];
}

@end


SPEC_BEGIN(ModuleUsageSpecs)

  beforeEach(^{
    MyModule *module = [[[MyModule alloc] initWithEngine:[[[Engine alloc] init] autorelease]] autorelease];    
    AddToContext(@"module", module);
    ObjectionInjector *injector = [Objection createInjector:module];
    [Objection setGlobalInjector:injector];
  });

  it(@"merges the modules instance binding with the injector's context", ^{
    MyModule *module = GetFromContext(@"module");
    assertThat([[Objection globalInjector] getObject:[Engine class]], is(sameInstance(module.engine)));
  });

  it(@"uses the module's bounded instance to fill out other objects dependencies", ^{
    MyModule *module = GetFromContext(@"module");
    Car *car = [[Objection globalInjector] getObject:[Car class]];
    
    assertThat(car.engine, is(sameInstance(module.engine)));    
  });

SPEC_END
