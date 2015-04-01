#import "SpecHelper.h"

@interface Person : NSObject
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSDictionary *namedAttributes;
@end

@implementation Person
objection_register(Person)
objection_requires(@"attributes")
objection_requires_names((@{@"NamedAttributes":@"namedAttributes"}))
@end

@interface Programmer : Person
@property (nonatomic, strong) NSDictionary *favoriteLanguages;
@property (nonatomic, strong) NSDictionary *favoriteBooks;
@end

@implementation Programmer
objection_register(Programmer)
objection_requires(@"favoriteLanguages")
objection_requires_names((@{@"FavoriteBooks":@"favoriteBooks"}))
@end

@interface NoInheritance : NSObject
@property (nonatomic, strong) NSString *something;
@property (nonatomic, strong) NSString *somethingElse;
@end

@implementation NoInheritance
objection_register(NoInheritance)
objection_requires(@"something")
objection_requires_names((@{@"SomethingElse":@"somethingElse"}))
@end

QuickSpecBegin(InheritanceSpecs)

beforeEach(^{
      JSObjectionInjector *injector = [JSObjection createInjector];
      [JSObjection setDefaultInjector:injector];
});

it(@"coalesces dependencies from parent to child", ^{
      Programmer *programmer = [[JSObjection defaultInjector] getObject:[Programmer class]];
      assertThat(programmer, is(notNilValue()));
      assertThat(programmer.favoriteLanguages, is(notNilValue()));
      assertThat(programmer.favoriteBooks, is(notNilValue()));
      assertThat(programmer.attributes, is(notNilValue()));
      assertThat(programmer.namedAttributes, is(notNilValue()));
});

it(@"does not throw a fit if the base class does not implement .objectionRequires", ^{
      NoInheritance *noParentObjectWithRequires = [[JSObjection defaultInjector] getObject:[NoInheritance class]];
      assertThat(noParentObjectWithRequires.something, is(notNilValue()));
      assertThat(noParentObjectWithRequires.somethingElse, is(notNilValue()));
});

QuickSpecEnd
