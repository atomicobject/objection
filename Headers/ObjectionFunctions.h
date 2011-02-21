#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum {
  ObjectionTypeClass,
  ObjectionTypeProtocol
} ObjectionType;

typedef struct objection_property_info {
  id object;
  ObjectionType type;
} ObjectionPropertyInfo;

ObjectionPropertyInfo ObjectionFindClassOrProtocolForProperty(objc_property_t property);
objc_property_t ObjectionGetProperty(Class klass, NSString *propertyName);
NSSet* ObjectionBuildDependenciesForClass(Class klass, NSSet *requirements);