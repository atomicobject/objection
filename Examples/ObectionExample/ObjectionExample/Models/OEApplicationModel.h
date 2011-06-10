//
//  OEApplicationModel.h
//  ObjectionExample
//
//  Created by Sean Fisk on 6/3/11.
//  Copyright 2011 Atomic Object. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OETableViewController;

@interface OEApplicationModel : NSObject {
	OETableViewController *_controller;
}

@property (nonatomic, assign) OETableViewController *controller;

@end
