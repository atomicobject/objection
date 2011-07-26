#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum {
  JSObjectionTypeClass,
  JSObjectionTypeProtocol
} JSObjectionType;

typedef struct objection_property_info {
  void *value;
  JSObjectionType type;
} JSObjectionPropertyInfo;

JSObjectionPropertyInfo JSFindClassOrProtocolForProperty(objc_property_t property);
objc_property_t JSGetProperty(Class klass, NSString *propertyName);
NSSet* JSBuildDependenciesForClass(Class klass, NSSet *requirements);