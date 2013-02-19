#import "KWSpec+FailWithException.h"

@implementation KWSpec (FailWithException)
+ (void)failWithException:(NSException *)exception {
    [exception raise];
}
@end
