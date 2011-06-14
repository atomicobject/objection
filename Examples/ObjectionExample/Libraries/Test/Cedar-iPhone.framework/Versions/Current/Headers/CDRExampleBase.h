#import <Foundation/Foundation.h>
#import "CDRExampleParent.h"

@protocol CDRExampleReporter;

typedef void (^CDRSpecBlock)(void);

enum CDRExampleState {
    CDRExampleStateIncomplete = 0x00,
    CDRExampleStatePassed = 0x01,
    CDRExampleStatePending = 0x03,
    CDRExampleStateFailed = 0x07,
    CDRExampleStateError = 0x0F
};
typedef enum CDRExampleState CDRExampleState;

@interface CDRSpecFailure : NSException
+ (id)specFailureWithReason:(NSString *)reason;
@end

@interface CDRExampleBase : NSObject {
  NSString *text_;
  id<CDRExampleParent> parent_;
}

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, assign) id<CDRExampleParent> parent;

- (id)initWithText:(NSString *)text;

- (void)run;
- (BOOL)hasChildren;
- (NSString *)message;
- (NSString *)fullText;
@end

@interface CDRExampleBase (RunReporting)
- (CDRExampleState)state;
- (float)progress;
@end
