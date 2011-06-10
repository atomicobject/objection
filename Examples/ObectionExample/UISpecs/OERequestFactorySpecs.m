#import "SpecHelper.h"
#import "OERequestFactory.h"

SPEC_BEGIN(OERequestFactorySpecs)

beforeEach(^{
	SetTarget(OERequestFactory);
});

describe(@"#requestWithRelativeURL:", ^{
	it(@"creates, configures, and returns a GitHub API prepared ASIHTTPRequest", ^{
		ASIHTTPRequest *request = [GetTarget() requestWithRelativeURL:@"path/to/resource/i/want"];
		assertThat(request.url, is([NSURL URLWithString:@"path/to/resource/i/want" relativeToURL:[NSURL URLWithString:kBaseURL]]));
		NSDictionary *requestHeaders = request.requestHeaders;
		assertThat([requestHeaders objectForKey:@"Accept"], is(kContentType));
		assertThat([requestHeaders objectForKey:@"Accept-Charset"], is(kContentEncoding));
		assertThatInt(request.cachePolicy, equalToInt(ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy));
		assertThatInt(request.cacheStoragePolicy, equalToInt(ASICacheForSessionDurationCacheStoragePolicy)); // default
	});
});

SPEC_END
