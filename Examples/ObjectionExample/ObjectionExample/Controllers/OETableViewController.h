//
//  OETableViewController.h
//  ObjectionExample
//
//  Created by Sean Fisk on 6/3/11.
//  Copyright 2011 Atomic Object. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OEApplicationModel.h"

@interface OETableViewController : UITableViewController {
	OEApplicationModel *_applicationModel;
  UIProgressView *_progressView;
}

@property (nonatomic, retain) OEApplicationModel *applicationModel;
@property (nonatomic, retain) UIProgressView *progressView;

- (void)reloadView;
- (void)showProgressView;
- (void)hideProgressView;
@end
