#import "OEAppDelegate.h"
#import "OETableViewController.h"
#import "OEObjectionModule.h"

@implementation OEAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  JSObjectionInjector *injector = [JSObjection createInjector:[[[OEObjectionModule alloc] init] autorelease]];
  [JSObjection setGlobalInjector:injector];
  self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
  self.navigationController = [[[UINavigationController alloc] initWithRootViewController:[[[OETableViewController alloc] initWithNibName:nil bundle:nil] autorelease]] autorelease];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

