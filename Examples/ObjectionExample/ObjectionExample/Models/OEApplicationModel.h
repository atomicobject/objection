//
//  OEApplicationModel.h
//  ObjectionExample
//
//  Created by Sean Fisk on 6/3/11.
//  Copyright 2011 Atomic Object. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEGitHubAPI.h"
#import "ASINetworkQueue.h"

@class OETableViewController;

extern NSString *const kDefaultAuthor;
extern NSString *const kDefaultRepo;
extern NSString *const kDefaultBranch;

@interface OEApplicationModel : NSObject {
	OETableViewController *_controller;
	OEGitHubAPI *_api;
  ASINetworkQueue *_networkQueue;
	NSArray *_commits;
}

@property (nonatomic, assign) OETableViewController *controller;
@property (nonatomic, retain) OEGitHubAPI *api;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;

@property (nonatomic, retain) NSArray *commits;

- (void)loadCommits;
- (NSInteger)numberOfCommits;
- (OECommit *)commitForIndex:(NSInteger)index;

@end
