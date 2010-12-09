#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static NSString *const ObjectionException = @"ObjectionException";

Class ObjectionFindClassForProperty(objc_property_t property) {
  NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];  
  NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
  
  NSRange startRange = [attributes rangeOfString:@"T@\""];
  if (startRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
  }
  
  NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
  NSRange endRange = [startOfClassName rangeOfString:@"\""];
  
  if (endRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];        
  }
  
  NSString *className = [startOfClassName substringToIndex:endRange.location];
  Class theClass = NSClassFromString(className);
  
  if(!theClass) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", className, propertyName] userInfo:nil];            
  }
  
  return theClass;      
}

objc_property_t ObjectionGetProperty(Class klass, NSString *propertyName) {
  objc_property_t property = class_getProperty(klass, (const char *)[propertyName UTF8String]);
  if (property == NULL) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
  }
  return property;
}