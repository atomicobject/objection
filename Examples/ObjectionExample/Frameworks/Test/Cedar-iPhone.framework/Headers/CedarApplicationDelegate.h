#import <UIKit/UIKit.h>

@class CDRExampleReporterViewController;

@interface CedarApplicationDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
    CDRExampleReporterViewController *viewController_;
}

@end
