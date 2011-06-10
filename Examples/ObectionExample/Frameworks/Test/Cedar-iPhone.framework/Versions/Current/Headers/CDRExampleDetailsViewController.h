#import <UIKit/UIKit.h>

@class CDRExampleBase;

@interface CDRExampleDetailsViewController : UIViewController {
    CDRExampleBase *example_;
    UINavigationBar *navigationBar_;
    UILabel *fullTextLabel_, *messageLabel_;
}

- (id)initWithExample:(CDRExampleBase *)example;

@end
