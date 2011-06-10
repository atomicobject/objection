#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

extern NSString *const kBaseURL;
extern NSString *const kContentType;
extern NSString *const kContentEncoding;

@interface OERequestFactory : NSObject {

}

- (ASIHTTPRequest *)requestWithRelativeURL:(NSString *)relativeURL;

@end
