#import "NSDateFormatter+TimeZoneFormat.h"

@implementation NSDateFormatter(TimeZoneFormat)
+ (NSDateFormatter *)timeZoneDesignatorFormatter {
  static NSDateFormatter *tzFormatter; 
  if (!tzFormatter) {
    tzFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocal = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [tzFormatter setLocale:enUSPOSIXLocal];
    [tzFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [tzFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
  }
  return tzFormatter;
}

@end
