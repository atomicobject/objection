#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern Class ObjectionFindClassForProperty(objc_property_t property);
extern objc_property_t ObjectionGetProperty(Class klass, NSString *propertyName);