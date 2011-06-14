#import "OEGitHubObjectBuilder.h"
#import "NSDateFormatter+TimeZoneFormat.h"

@implementation OEGitHubObjectBuilder
objection_register(OEGitHubObjectBuilder)

- (OECommit *)buildCommit:(NSDictionary *)commitDictionary {
	OECommit *commit = [[[OECommit alloc] init] autorelease];
  commit.authorName = [[commitDictionary objectForKey:@"author"] objectForKey:@"name"];
  commit.authoredDate = [self parseGitHubDateString:[commitDictionary objectForKey:@"authored_date"]];
  commit.message = [commitDictionary objectForKey:@"message"];
  return commit;
}

- (NSDate *)parseGitHubDateString:(NSString *)dateString {
  NSString *tzString = [[dateString substringToIndex:[dateString length] - 3] stringByAppendingString:[dateString substringFromIndex:[dateString length] - 2]];
  NSDateFormatter *formatter = [NSDateFormatter timeZoneDesignatorFormatter];
  return [formatter dateFromString:tzString];
}

@end
