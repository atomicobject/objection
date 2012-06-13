#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NSString *const JSObjectionInitializerKey;
NSString *const JSObjectionDefaultArgumentsKey;

typedef enum {
    JSObjectionTypeClass,
    JSObjectionTypeProtocol
} JSObjectionType;

typedef struct objection_property_info {
    void *value;
    JSObjectionType type;
} JSObjectionPropertyInfo;

extern const struct JSObjectionUtils {
    JSObjectionPropertyInfo (*findClassOrProtocolForProperty)(objc_property_t property);
    objc_property_t (*propertyForClass)(Class klass, NSString *propertyName);
    NSSet* (*buildDependenciesForClass)(Class klass, NSSet *requirements);
    NSDictionary* (*buildInitializer)(SEL selector, NSArray *arguments);
    NSArray* (*transformVariadicArgsToArray)(va_list va_arguments);
    id (*buildObjectWithInitializer)(Class klass, SEL initializer, NSArray *arguments);
} JSObjectionUtils;