//
//  OEAppDelegate.h
//  ObjectionExample
//
//  Created by Sean Fisk on 6/3/11.
//  Copyright 2011 Atomic Object. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OEAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

