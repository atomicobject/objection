#import "SpecHelper.h"
#import "OETableViewController.h"
#import "OEApplicationModel.h"

SPEC_BEGIN(OEApplicationModelSpecs)

beforeEach(^{
	SetTarget(OEApplicationModel);
	mockProperties(GetTarget(), @"controller", @"api", @"networkQueue", nil);
});

describe(@"#awakeFromObjection", ^{
  it(@"it configures itself as a delegate to the network queue", ^{
    [[m(@"networkQueue") expect] setDelegate:GetTarget()];
    [[m(@"networkQueue") expect] setQueueDidFinishSelector:@selector(queueDidFinish:)];
    [GetTarget() awakeFromObjection];
  });
});

describe(@"#loadCommits", ^{	
	it(@"loads the GitHub commit data into the model on completion", ^{
		OCMCaptureConstraint *completedBlockConstraint = [[[OCMCaptureConstraint alloc] init] autorelease];

    [[[m(@"controller") stub] andReturn:@"progressView"] progressView];
    [[m(@"networkQueue") expect] setDownloadProgressDelegate:(id)@"progressView"];
    [[m(@"controller") expect] showProgressView];
		[[m(@"api") expect] commitsWithAuthor:kDefaultAuthor inRepository:kDefaultRepo onBranch:kDefaultBranch completed:(id)completedBlockConstraint];
    		
		[GetTarget() loadCommits];
    
    [[m(@"controller") expect] reloadView];

		void (^completionBlock)(NSArray *) = completedBlockConstraint.argument;
    
		completionBlock([NSArray arrayWithObjects:@"commit1", @"commit2", nil]);
		
		assertThat([GetTarget() commits], is([NSArray arrayWithObjects:@"commit1", @"commit2", nil]));
	});
});

describe(@"#queueDidFinish:", ^{
  it(@"hides the progress view", ^{
    [[m(@"controller") expect] hideProgressView];
    [GetTarget() performSelector:@selector(queueDidFinish:) withObject:nil];
  });
});

afterEach(^{
	verifyMocks();
});

itRequiresDependencies(OEApplicationModel, @"api", @"networkQueue")

SPEC_END