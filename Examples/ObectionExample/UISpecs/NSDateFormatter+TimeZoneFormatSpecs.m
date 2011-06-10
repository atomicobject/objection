#import "SpecHelper.h"
#import "NSDateFormatter+TimeZoneFormat.h"

SPEC_BEGIN(NSDateFormatterSpecs)

describe(@"#timeZoneDesignatorFormatter", ^{
  it(@"correctly parses a date", ^{
    NSDateFormatter *formatter = [NSDateFormatter timeZoneDesignatorFormatter];
    NSDate *date = [formatter dateFromString:@"2010-12-09T13:50:17-0800"];
    assertThat(date, is(ParseDateString(@"2010-12-09 13:50:17 -0800")));
  });
});

SPEC_END
