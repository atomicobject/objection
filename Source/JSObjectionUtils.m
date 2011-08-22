#import <objc/runtime.h>
#import "JSObjectionUtils.h"

static NSString *const JSObjectionException = @"JSObjectionException";

static JSObjectionPropertyInfo FindClassOrProtocolForProperty(objc_property_t property) 
{
  NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];  
  NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
  
  NSRange startRange = [attributes rangeOfString:@"T@\""];
  if (startRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:JSObjectionException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
  }
  
  NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
  NSRange endRange = [startOfClassName rangeOfString:@"\""];
  
  if (endRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:JSObjectionException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];        
  }
  
  NSString *classOrProtocolName = [startOfClassName substringToIndex:endRange.location];
  id classOrProtocol = nil;
  JSObjectionPropertyInfo propertyInfo;
  
  if ([classOrProtocolName hasPrefix:@"<"] && [classOrProtocolName hasSuffix:@">"]) {
    classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@"<" withString:@""];
    classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@">" withString:@""];
    classOrProtocol = objc_getProtocol([classOrProtocolName UTF8String]);
    propertyInfo.type = JSObjectionTypeProtocol;
  } else {
    classOrProtocol = NSClassFromString(classOrProtocolName);
    propertyInfo.type = JSObjectionTypeClass;
  }
  
  if(!classOrProtocol) {
    @throw [NSException exceptionWithName:JSObjectionException reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", classOrProtocolName, propertyName] userInfo:nil];            
  }
  propertyInfo.value = classOrProtocol;
  
  return propertyInfo;      
}

static NSSet* BuildDependenciesForClass(Class klass, NSSet *requirements) 
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

static objc_property_t GetProperty(Class klass, NSString *propertyName) 
{
  objc_property_t property = class_getProperty(klass, (const char *)[propertyName UTF8String]);
  if (property == NULL) {
    @throw [NSException exceptionWithName:JSObjectionException reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
  }
  return property;
}

const struct JSObjectionUtils JSObjectionUtils = {
  .findClassOrProtocolForProperty = FindClassOrProtocolForProperty,
  .propertyForClass = GetProperty,
  .buildDependenciesForClass = BuildDependenciesForClass
};
