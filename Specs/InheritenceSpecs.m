#import "SpecHelper.h"

@interface Person : NSObject
{
  NSDictionary *_attributes;
}

@property (nonatomic, retain) NSDictionary *attributes;
@end

@implementation Person
objection_register(@"Person")
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
objection_register(@"Programmer")
objection_requires(@"favoriteLanguages")
@synthesize favoriteLanguages=_favoriteLanguages;

@end

@interface NoInheritence : NSObject
{
  NSString *_something;
}

@property (nonatomic, retain) NSString *something;

@end

@implementation NoInheritence
objection_register(@"NoInheritence")
objection_requires(@"something")

@synthesize something=_something;

@end





SPEC_BEGIN(InheritenceSpecs)
  it(@"coalesces dependencies from parent to child", ^{
    Programmer *programmer = [ObjectionInjector getObject:[Programmer class]];
    assertThat(programmer.attributes, is(notNilValue()));
    assertThat(programmer.favoriteLanguages, is(notNilValue()));
  });

  it(@"does not throw a fit if the base class does not implement super", ^{
    NoInheritence *noParentObjectWithRequires = [ObjectionInjector getObject:[NoInheritence class]];
    assertThat(noParentObjectWithRequires.something, is(notNilValue()));
  });
SPEC_END
