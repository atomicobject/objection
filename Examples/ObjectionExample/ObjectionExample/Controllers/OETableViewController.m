#import "OETableViewController.h"
#import "OECommit.h"


@implementation OETableViewController

@synthesize applicationModel = _applicationModel;
@synthesize progressView = _progressView;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {    
		self.applicationModel = [[JSObjection globalInjector] getObject:[OEApplicationModel class]];
		self.applicationModel.controller = self;    
    self.title = @"Commits";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
	[self.applicationModel loadCommits];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.progressView = nil;
}

- (void)reloadView {
  [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Loading progress

- (void)showProgressView {
	if (self.navigationItem.titleView == nil) {
		self.navigationItem.titleView = self.progressView;
	}
}

- (void)hideProgressView {
	self.navigationItem.titleView = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.applicationModel numberOfCommits];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
  }
  
  // Configure the cell.
  OECommit *commit = [self.applicationModel commitForIndex:indexPath.row];
  cell.textLabel.text = commit.message;
  cell.detailTextLabel.text = commit.authorName;

    return cell;
}

- (void)dealloc {  
  [_progressView release]; _progressView = nil;
	[_applicationModel release];
  [super dealloc];
}


@end

