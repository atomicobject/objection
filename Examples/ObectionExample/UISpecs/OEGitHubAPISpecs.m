#import "SpecHelper.h"
#import "OEGitHubAPI.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

SPEC_BEGIN(OEGitHubAPISpecs)

beforeEach(^{
	SetTarget(OEGitHubAPI);
	AddToContext(@"request", mock(ASIHTTPRequest));
	mockProperties(GetTarget(), @"requestFactory", @"builder", @"networkQueue", nil);
});

describe(@"#commitsWithAuthor:inRepository:onBranch:completed:", ^{
	it(@"creates, configures, and submits a query to the GitHub API using the specified information", ^{
		[[[m(@"requestFactory") expect] andReturn:m(@"request")] requestWithRelativeURL:@"author/repo/branch"];
		[[m(@"request") expect] setCompletionBlock:OCMOCK_ANY];
		[[m(@"request") expect] setFailedBlock:OCMOCK_ANY];
    [[m(@"networkQueue") expect] addOperation:m(@"request")];
    [[m(@"networkQueue") expect] go];
		
		[GetTarget() commitsWithAuthor:@"author" inRepository:@"repo" onBranch:@"branch" completed:^(NSArray *commits){}];
	});
	
	describe(@"completed block", ^{
    beforeEach(^{
      [[m(@"networkQueue") stub] addOperation:OCMOCK_ANY];
      [[m(@"networkQueue") stub] go];      
			[[m(@"request") stub] setFailedBlock:OCMOCK_ANY];
    });
    
		it(@"converts the response data into commits and invokes the completed block", ^{
			OCMCaptureConstraint *completedBlockConstraint = [[[OCMCaptureConstraint alloc] init] autorelease];
			[[[m(@"requestFactory") stub] andReturn:m(@"request")] requestWithRelativeURL:@"author/repo/branch"];
			[[m(@"request") stub] setCompletionBlock:(id)completedBlockConstraint];
			
			__block NSArray *gotCommits = nil;
			NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ci1", @"ci2", nil] forKey:@"commits"];
			
			[[[m(@"request") stub] andReturn:[dictionary JSONData]] responseData];
			[[[m(@"builder") expect] andReturn:@"built ci1"] buildCommit:(id)@"ci1"];
			[[[m(@"builder") expect] andReturn:@"built ci2"] buildCommit:(id)@"ci2"];
			
			[GetTarget() commitsWithAuthor:@"author" inRepository:@"repo" onBranch:@"branch" completed:^(NSArray *commits){
				gotCommits = commits;
			}];
			void (^block)(void) = [completedBlockConstraint argument];
			block();
			
			assertThat(gotCommits, is([NSArray arrayWithObjects:@"built ci1", @"built ci2", nil]));
		});
	});
});

itRequiresDependencies(OEGitHubAPI, @"requestFactory", @"builder", @"networkQueue", nil)

afterEach(^{
	verifyMocks();
});

SPEC_END
