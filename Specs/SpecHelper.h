#define __SPEC_HELPER

#define HC_SHORTHAND

#if TARGET_OS_IPHONE
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#else
#import <OCHamcrest/OCHamcrest.h>
#endif

#import "Objection.h"
#define QUICK_DISABLE_SHORT_SYNTAX 1
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#define NSINT(__i) ([NSNumber numberWithInt:__i])