#define __SPEC_HELPER

#define HC_SHORTHAND
#if TARGET_OS_IPHONE
#import <Cedar-iPhone/SpecHelper.h>
#import <OCHamcrest-iPhone/OCHamcrest.h>
#else
#import <Cedar/SpecHelper.h>
#import <OCHamcrest/OCHamcrest.h>
#endif

#import <OCMock/OCMock.h>
#import <Objection-iOS/Objection.h>
#import "OCMockRecorder+PrimitiveReturnMethods.h"

extern id AddToContext(NSString *key, id value);
extern id GetFromContext(NSString *key);
extern NSString* ReadFile(NSString *fileName);
extern NSData* ReadFileAsData(NSString *fileName);
extern id ParseJSONFile(NSString *fileName);
extern NSDate* ParseDateString(NSString *dateString);
extern NSDate* ParseDateStringForTZ(NSString *dateString, NSTimeZone *timeZone);
extern NSDate* ParseSimpleDateString(NSString *dateString);
extern id m(NSString *key);
extern void WhileLocked(void (^lockingBlock)());
extern void WhileTimeZoneIs(NSString *timeZone, void(^lockingBlock)());
extern void assertRaises(void(^block)(), NSString *expectedReason);
extern void BuildApplicationContext();
extern id mockProperty(id target, NSString *propertyName);
extern id mockPropertyForClass(id target, NSString *propertyName, Class theClass);
extern void verifyMocks();
extern void mockProperties(id target, id property, ...) NS_REQUIRES_NIL_TERMINATION;

@interface NSDate(SRTestHarness)
+ (void)setFakeDate:(NSDate *)date;
+ (void)enableDateStubbing;
+ (void)disableDateStubbing;
@end

#define SetTarget(__CLASS) AddToContext(@"target", [[[__CLASS alloc] init] autorelease])
#define SetInstanceTarget(__OBJECT) AddToContext(@"target", __OBJECT)
#define ConfigureStyles() [TTStyleSheet setGlobalStyleSheet:[[[WCStyleSheet alloc] init] autorelease]];

#define GetTarget() GetFromContext(@"target")

#define ResetRoutes() [[TTNavigator navigator].URLMap removeAllObjects]
#define NSINT(__i) ([NSNumber numberWithInt:__i])

#define itRequiresDependencies(classSymbol, args...) \
  describe(@".objectionRequires", ^{ \
  	it(@"returns a list of dependencies", ^{ \
			if(![[classSymbol class] respondsToSelector:@selector(objectionRequires)]) { \
				fail([NSString stringWithFormat:@"%@ does not respond to objectionRequires class method", NSStringFromClass([classSymbol class])]); \
			} \
    	assertThat([[classSymbol class] performSelector:@selector(objectionRequires)], equalTo([NSSet setWithObjects: args, nil])); \
  	}); \
	});

#define mock(classSymbol) [OCMockObject mockForClass:[classSymbol class]]

@interface SpecHelper(Locking)
+ (void)whileLocked:(void (^)())lockingBlock;
@end
