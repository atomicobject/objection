#import <objc/runtime.h>
#import "ObjectionFunctions.h"

static NSString *const ObjectionException = @"ObjectionException";

ObjectionPropertyInfo ObjectionFindClassOrProtocolForProperty(objc_property_t property) 
{
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
  
  NSString *classOrProtocolName = [startOfClassName substringToIndex:endRange.location];
  id classOrProtocol = nil;
  ObjectionPropertyInfo propertyInfo;
  
  if ([classOrProtocolName hasPrefix:@"<"] && [classOrProtocolName hasSuffix:@">"]) {
    classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@"<" withString:@""];
    classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@">" withString:@""];
    classOrProtocol = objc_getProtocol([classOrProtocolName UTF8String]);
    propertyInfo.type = ObjectionTypeProtocol;
  } else {
    classOrProtocol = NSClassFromString(classOrProtocolName);
    propertyInfo.type = ObjectionTypeClass;
  }
  
  if(!classOrProtocol) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", classOrProtocolName, propertyName] userInfo:nil];            
  }
  propertyInfo.value = classOrProtocol;
  
  return propertyInfo;      
}

NSSet* ObjectionBuildDependenciesForClass(Class klass, NSSet *requirements) 
{
  Class superClass = class_getSuperclass([klass class]);
  if([superClass respondsToSelector:@selector(objectionRequires)]) {
    NSSet *parentsRequirements = [superClass performSelector:@selector(objectionRequires)];
    NSMutableSet *dependencies = [NSMutableSet setWithSet:parentsRequirements];
    [dependencies unionSet:requirements];
    requirements = dependencies;
  }
  return requirements;  
}

objc_property_t ObjectionGetProperty(Class klass, NSString *propertyName) 
{
  objc_property_t property = class_getProperty(klass, (const char *)[propertyName UTF8String]);
  if (property == NULL) {
    @throw [NSException exceptionWithName:ObjectionException reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
  }
  return property;
}