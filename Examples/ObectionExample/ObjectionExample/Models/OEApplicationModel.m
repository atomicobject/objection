#import "OEApplicationModel.h"
#import "OETableViewController.h"

NSString *const kDefaultAuthor = @"atomicobject";
NSString *const kDefaultRepo = @"objection";
NSString *const kDefaultBranch = @"master";

@implementation OEApplicationModel
objection_register(OEApplicationModel)
objection_requires(@"api", @"networkQueue")

@synthesize controller = _controller;
@synthesize api = _api;
@synthesize networkQueue = _networkQueue;
@synthesize commits = _commits;

- (void)awakeFromObjection {
  self.networkQueue.delegate = self;
  self.networkQueue.queueDidFinishSelector = @selector(queueDidFinish:);
}

- (void)loadCommits {
  self.networkQueue.downloadProgressDelegate = self.controller.progressView;
  [self.controller showProgressView];
	[self.api commitsWithAuthor:kDefaultAuthor inRepository:kDefaultRepo onBranch:kDefaultBranch completed:^(NSArray *commits){
		self.commits = commits;
    [self.controller reloadView];
	}];
}

- (NSInteger)numberOfCommits {
  return [self.commits count];
}

- (OECommit *)commitForIndex:(NSInteger)index {
  return [self.commits objectAtIndex:index];
}

- (void)queueDidFinish:(id)queue {
  [self.controller hideProgressView];
}

- (void)dealloc {
  [_networkQueue release];
	[_api release];
	[super dealloc];
}

@end
