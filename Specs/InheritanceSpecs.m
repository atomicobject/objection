#import "SpecHelper.h"

@interface Person : NSObject
{
  NSDictionary *_attributes;
}

@property (nonatomic, strong) NSDictionary *attributes;
@end

@implementation Person
objection_register(Person)
objection_requires(@"attributes")
@synthesize attributes=_attributes;
@end

@interface Programmer : Person
{
  NSDictionary *_favoriteLanguages;
}
@property (nonatomic, strong) NSDictionary *favoriteLanguages;
@end

@implementation Programmer
objection_register(Programmer)
objection_requires(@"favoriteLanguages")
@synthesize favoriteLanguages=_favoriteLanguages;

@end

@interface NoInheritance : NSObject
{
  NSString *_something;
}

@property (nonatomic, strong) NSString *something;

@end

@implementation NoInheritance
objection_register(NoInheritance)
objection_requires(@"something")

@synthesize something=_something;

@end


SPEC_BEGIN(InheritanceSpecs)
beforeEach(^{
      JSObjectionInjector *injector = [JSObjection createInjector];
      [JSObjection setDefaultInjector:injector];
});

it(@"coalesces dependencies from parent to child", ^{
      Programmer *programmer = [[JSObjection defaultInjector] getObject:[Programmer class]];
      assertThat(programmer, is(notNilValue()));
      assertThat(programmer.favoriteLanguages, is(notNilValue()));
      assertThat(programmer.attributes, is(notNilValue()));
});

it(@"does not throw a fit if the base class does not implement .objectionRequires", ^{
      NoInheritance *noParentObjectWithRequires = [[JSObjection defaultInjector] getObject:[NoInheritance class]];
      assertThat(noParentObjectWithRequires.something, is(notNilValue()));
});
SPEC_END
