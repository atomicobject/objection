#import "OEGitHubAPI.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation OEGitHubAPI
objection_register(OEGitHubAPI)
objection_requires(@"requestFactory", @"builder", @"networkQueue")

@synthesize requestFactory = _requestFactory;
@synthesize builder = _builder;
@synthesize networkQueue = _networkQueue;

- (void)commitsWithAuthor:(NSString *)author inRepository:(NSString *)repo onBranch:(NSString *)branch completed:(void (^)(NSArray *))completedBlock {
    // There's no documentation in the GitHub API v3 to get the commits from a branch
    // TODO: Use the repo parameter when the documentation includes getting the commits from a branch
    // http://developer.github.com/v3/repos/commits/
	ASIHTTPRequest *request = [self.requestFactory requestWithRelativeURL:[NSString stringWithFormat:@"%@/%@/commits", author, repo]];
	
	[request setCompletionBlock:^{
        NSArray *commitDictionaries = [[request responseData] objectFromJSONData];
        NSMutableArray *commits = [[[NSMutableArray alloc] init] autorelease];
        for (NSDictionary *commitDictionary in commitDictionaries) {
            [commits addObject:[self.builder buildCommit:[commitDictionary objectForKey:@"commit"]]];
        }
        completedBlock(commits);
	}];
	[request setFailedBlock:^{
		NSLog(@"Network Error: %@", [request error]);
	}];
  [self.networkQueue addOperation:request];
  [self.networkQueue go];
}

- (void)dealloc {
    [_networkQueue release];
	[_requestFactory release];
	[_builder release];
	[super dealloc];
}

@end
