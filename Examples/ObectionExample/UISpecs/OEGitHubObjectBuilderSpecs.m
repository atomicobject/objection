#import "SpecHelper.h"
#import "OEGitHubObjectBuilder.h"

SPEC_BEGIN(OEGitHubObjectBuilderSpecs)

beforeEach(^{
  SetTarget(OEGitHubObjectBuilder);
});

describe(@"#buildCommit:", ^{
  it(@"builds a commit from a commit dictionary", ^{
    NSDictionary *commitDictionary = ParseJSONFile(@"commit.json");
    assertThat(commitDictionary, isNot(nilValue())); // sanity check
    
    OECommit *commit = [GetTarget() buildCommit:commitDictionary];
    
    assertThat(commit.authorName, is(@"Justin DeWind"));
    assertThat(commit.authoredDate, is(ParseDateString(@"2011-06-02 09:08:47 -0700")));
    assertThat(commit.message, is(@"Updated globalInjector getter to return injector using retain/autorelease"));
	});  
});

describe(@"#parseGitHubDateString:", ^{
  it(@"correctly parses a date string from GitHub", ^{
    NSDate *date = [GetTarget() parseGitHubDateString:@"2010-12-09T13:50:17-08:00"];
    assertThat(date, is(ParseDateString(@"2010-12-09 13:50:17 -0800")));
  });
});

SPEC_END
