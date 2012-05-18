#import "CircularDependencyFixtures.h"
#import "SpecHelper.h"
#import "Fixtures.h"

SPEC_BEGIN(CircularDependencySpecs)
describe(@"circular dependencies", ^{
      beforeEach(^{
            JSObjectionInjector *injector = [JSObjection createInjector];
            [JSObjection setDefaultInjector:injector];
      });

      it(@"are resolved between singletons", ^{
            SingletonFoo *foo = [[JSObjection defaultInjector] getObject:[SingletonFoo class]];
            SingletonBar *bar = [[JSObjection defaultInjector] getObject:[SingletonBar class]];

            assertThat(foo, is(sameInstance(bar.foo)));
            assertThat(foo.bar, is(sameInstance(bar)));
      });
});
SPEC_END