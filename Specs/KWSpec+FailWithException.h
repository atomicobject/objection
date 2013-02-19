#import "KWSpec.h"

@interface KWSpec (FailWithException)
+ (void)failWithException:(NSException *)exception;
@end
