#import "SpecHelper.h"

void assertRaises(void(^block)(), NSString *expectedReason) {
  @try {
    block();
    fail(@"Should have raised an exception");
  }
  @catch (NSException * e) {
    if ([[e name] isEqualToString:@"Spec failure"]) {
      @throw e;
    }
    if (![[e reason] isEqualToString:expectedReason]) {
      fail([NSString stringWithFormat: @"Expected to raise exception with reason: %@ got: %@", expectedReason, [e reason]]);
    }
  }        
}