#import "SpecHelper.h"

@interface Person : NSObject
{
  NSDictionary *_attributes;
}

@property (nonatomic, retain) NSDictionary *attributes;
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
@property (nonatomic, retain) NSDictionary *favoriteLanguages;
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

@property (nonatomic, retain) NSString *something;

@end

@implementation NoInheritance
objection_register(NoInheritance)
objection_requires(@"something")

@synthesize something=_something;

@end


SPEC_BEGIN(InheritanceSpecs)
beforeEach(^{
  JSObjectionInjector *injector = [JSObjection createInjector];
  [JSObjection setGlobalInjector:injector];
});

it(@"coalesces dependencies from parent to child", ^{
  Programmer *programmer = [[JSObjection globalInjector] getObject:[Programmer class]];
  assertThat(programmer, is(notNilValue()));
  assertThat(programmer.favoriteLanguages, is(notNilValue()));
  assertThat(programmer.attributes, is(notNilValue()));
});

it(@"does not throw a fit if the base class does not implement .objectionRequires", ^{
  NoInheritance *noParentObjectWithRequires = [[JSObjection globalInjector] getObject:[NoInheritance class]];
  assertThat(noParentObjectWithRequires.something, is(notNilValue()));
});
SPEC_END
