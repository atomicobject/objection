//
//  OEGitHubAPI.h
//  ObjectionExample
//
//  Created by Sean Fisk on 6/3/11.
//  Copyright 2011 Atomic Object. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OERequestFactory.h"
#import "OEGitHubObjectBuilder.h"
#import "ASINetworkQueue.h"

@interface OEGitHubAPI : NSObject {
	OERequestFactory *_requestFactory;
	OEGitHubObjectBuilder *_builder;
  ASINetworkQueue *_networkQueue;
}

@property (nonatomic, retain) OERequestFactory *requestFactory;
@property (nonatomic, retain) OEGitHubObjectBuilder *builder;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;

- (void)commitsWithAuthor:(NSString *)author inRepository:(NSString *)repo onBranch:(NSString *)branch completed:(void (^)(NSArray *))completedBlock;

@end
