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
	ASIHTTPRequest *request = [self.requestFactory requestWithRelativeURL:[NSString stringWithFormat:@"%@/%@/%@", author, repo, branch]];
	
	[request setCompletionBlock:^{
		NSArray *commitDictionaries = [[[request responseData] objectFromJSONData] objectForKey:@"commits"];
		NSMutableArray *commits = [[[NSMutableArray alloc] init] autorelease];
		for (NSDictionary *commitDictionary in commitDictionaries) {
      [commits addObject:[self.builder buildCommit:commitDictionary]];
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
