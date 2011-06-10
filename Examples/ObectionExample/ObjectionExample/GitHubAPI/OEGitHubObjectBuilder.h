#import <Foundation/Foundation.h>
#import "OECommit.h"

@interface OEGitHubObjectBuilder : NSObject {

}

- (OECommit *)buildCommit:(NSDictionary *)commitDictionary;
- (NSDate *)parseGitHubDateString:(NSString *)dateString;

@end
