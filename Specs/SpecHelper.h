#define __SPEC_HELPER

#define HC_SHORTHAND

#if TARGET_OS_IPHONE
#import <OCHamcrest-iPhone/OCHamcrest.h>
#else
#import <OCHamcrest/OCHamcrest.h>
#endif

#import "Objection.h"
#import "Kiwi.h"
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#define NSINT(__i) ([NSNumber numberWithInt:__i])