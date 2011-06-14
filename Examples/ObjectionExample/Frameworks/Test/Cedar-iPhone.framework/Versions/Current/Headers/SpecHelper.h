#import "CDRSpec.h"
#import "CDRSharedExampleGroupPool.h"
#import "CDRExampleParent.h"

@interface SpecHelper : NSObject <CDRExampleParent> {
    NSMutableDictionary *sharedExampleGroups_, *sharedExampleContext_;
}

@property (nonatomic, retain, readonly) NSMutableDictionary *sharedExampleContext;

+ (SpecHelper *)specHelper;

- (void)beforeEach;
- (void)afterEach;

@end
