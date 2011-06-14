#import "SpecHelper.h"
#import "OEObjectionModule.h"
#import "ASINetworkQueue.h"

SPEC_BEGIN(OEObjectionModuleSpecs)

beforeEach(^{
  SetTarget(OEObjectionModule);
});

it(@"configures bindings to external dependencies", ^{
  [GetTarget() configure];
  assertThat([[[GetTarget() bindings] objectForKey:@"ASINetworkQueue"] extractObject], is(instanceOf([ASINetworkQueue class])));
});

SPEC_END
