#import "SpecHelper.h"
#import <objc/runtime.h>
#import "JSONKit.h"

static NSLock *gSpecHelperLock;
@implementation SpecHelper(Locking)

+ (void) initialize {
  if ((self = [SpecHelper class])) {
    gSpecHelperLock = [[NSLock alloc] init];
  }
}

+ (void)whileLocked:(void (^)())lockingBlock {
  [gSpecHelperLock lock];
  @try {
    lockingBlock();
  }
  @finally {
    [gSpecHelperLock unlock];
  }
}
@end

void WhileLocked(void (^lockingBlock)()) {
  [SpecHelper whileLocked:lockingBlock];
}

extern void WhileTimeZoneIs(NSString *timeZone, void(^block)()) {
  NSTimeZone *currentTimeZone = [NSTimeZone defaultTimeZone];
  @try {
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZone]];
    block();
  }
  @finally {
    [NSTimeZone setDefaultTimeZone:currentTimeZone];
  }
}

id AddToContext(NSString *key, id value) {
	[[SpecHelper specHelper].sharedExampleContext setObject:value forKey:key];
	return value;
}

id m(NSString *key) {
  id var = GetFromContext(key);
  NSCAssert(var != nil, @"Attempted to retrieve object from context that did not exist");
  return var;
}

id GetFromContext(NSString *key) {
  return [[SpecHelper specHelper].sharedExampleContext objectForKey:key];
}

NSString* ReadFile(NSString *fileName) {
  NSData *fileData = ReadFileAsData(fileName);
  return [[[NSString alloc] initWithData: fileData encoding: NSASCIIStringEncoding] autorelease];	
}

NSData* ReadFileAsData(NSString *fileName) {
  return [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:fileName ofType:nil]];  
}


id ParseJSONFile(NSString *fileName) {
  return [ReadFileAsData(fileName) objectFromJSONData];
}

NSDate* ParseDateString(NSString *dateString) {
  static NSDateFormatter *_formatter; 
  if (!_formatter) {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss Z"];
  } 
  
  return [_formatter dateFromString:dateString];  
}

NSDate* ParseSimpleDateString(NSString *dateString) {
  return ParseDateStringForTZ(dateString, [NSTimeZone defaultTimeZone]);
}

NSDate* ParseDateStringForTZ(NSString *dateString, NSTimeZone *timeZone) {
  static NSDateFormatter *_formatter; 
  if (!_formatter) {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss Z"];
  } 
  
  NSInteger hoursBeforeGMT = fabs([timeZone secondsFromGMT] / 60 / 60);
  dateString = [NSString stringWithFormat:[dateString stringByAppendingString:@" -0%d00"], hoursBeforeGMT];  
  
  return [_formatter dateFromString:dateString];  
}

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

NSString * _parseClassOrProtocolName(NSString *propertyName,id target) {
  objc_property_t property = class_getProperty([target class], (const char *)[propertyName UTF8String]);
  
  if (!property) {
    fail([NSString stringWithFormat:@"Unable to find property '%@ on %@", propertyName, NSStringFromClass([target class])]);
  }
  
  NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];  
  
  NSRange startRange = [attributes rangeOfString:@"T@\""];
  if (startRange.location == NSNotFound) {
    fail([NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName]);
  }
  
  NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
  NSRange endRange = [startOfClassName rangeOfString:@"\""];
  
  if (endRange.location == NSNotFound) {
    fail([NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName]);        
  }
  
  return [startOfClassName substringToIndex:endRange.location];
}

id mockProperty(id target, NSString *propertyName) {
  
  NSString *className = _parseClassOrProtocolName(propertyName,target);  
  id theClass = nil;
  SEL mockSelector;
  
  if ([className hasPrefix:@"<"] && [className hasSuffix:@">"]) {
    className = [className stringByReplacingOccurrencesOfString:@"<" withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@">" withString:@""];
    theClass = objc_getProtocol([className UTF8String]);
    mockSelector = @selector(mockForProtocol:);
  } else {
    theClass = NSClassFromString(className);    
    mockSelector = @selector(mockForClass:);
  }

  if(!theClass) {
    fail([NSString stringWithFormat:@"Unable get class or protocol for '%@' for property '%@'", className, propertyName]);            
  }
  
  id mock = AddToContext(propertyName, [OCMockObject performSelector:mockSelector withObject:theClass]);
  [target setValue:mock forKey:propertyName];  
  return mock;      
}


void mockProperties(id target, id property, ...) {
  va_list args;
  va_start(args, property);
  id arg;
  for (arg = property; arg != nil; arg = va_arg(args, id))
    mockProperty(target, arg);
}


id mockPropertyForClass(id target, NSString *propertyName, Class theClass) {
  id mock = AddToContext(propertyName, [OCMockObject mockForClass:theClass]);
  [target setValue:mock forKey:propertyName];
  return mock;
}

void verifyMocks() {
  for(NSString *key in [SpecHelper specHelper].sharedExampleContext) {
    id object = GetFromContext(key);
    if([object superclass] == NSClassFromString(@"OCMockObject") || [object class] == NSClassFromString(@"OCObserverMockObject")) {
      [object verify];
    }
  }
}

static NSDate *_srGlobalDate = nil;
static NSDate* FakeDateMethodImpl(id obj, SEL _sel) {
  return _srGlobalDate;
}

static IMP gOriginalDateMethod = nil;

@implementation NSDate(SRTestHarness)
+ (void)setFakeDate:(NSDate *)date {
  if (_srGlobalDate != date) {
    [_srGlobalDate release]; _srGlobalDate = nil;
    _srGlobalDate = [date retain];
  }
}

+ (void)enableDateStubbing {
  Method dateMethod = class_getClassMethod([self class], @selector(date));
  gOriginalDateMethod = method_getImplementation(dateMethod);
  method_setImplementation(dateMethod, (IMP)FakeDateMethodImpl);
}

+ (void)disableDateStubbing {
  if (gOriginalDateMethod) {
    Method dateMethod = class_getClassMethod([self class], @selector(date));
    method_setImplementation(dateMethod, gOriginalDateMethod);
  } 
}
@end