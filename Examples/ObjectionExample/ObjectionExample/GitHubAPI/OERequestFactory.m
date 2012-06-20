#import "OERequestFactory.h"

NSString *const kBaseURL = @"https://api.github.com/repos/";
NSString *const kContentType = @"application/json";
NSString *const kContentEncoding = @"UTF-8";

@implementation OERequestFactory
objection_register(OERequestFactory)

- (ASIHTTPRequest *)requestWithRelativeURL:(NSString *)relativeURL {
	NSURL *url = [NSURL URLWithString:relativeURL relativeToURL:[NSURL URLWithString:kBaseURL]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
    NSLog(@"Requesting Commits: %@", [url absoluteString]);
	// Extra headers - ensure correct values
	[request addRequestHeader:@"Accept" value:kContentType];
	[request addRequestHeader:@"Accept-Charset" value:kContentEncoding];
	
	// Set cache policies for request - ask if modified when cache is stale, and fallback to cache when the request fails
	request.cachePolicy = ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy;
	
	// Set cache storage policy - only keep for session
	request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
	
	return request;
}

@end
