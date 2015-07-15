#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString *const JSObjectionInitializerKey;
extern NSString *const JSObjectionDefaultArgumentsKey;

typedef enum {
    JSObjectionTypeClass,
    JSObjectionTypeProtocol
} JSObjectionType;


typedef struct JSObjectionPropertyInfo {
    __unsafe_unretained id value;
    JSObjectionType type;
} JSObjectionPropertyInfo;


@protocol JSObjectionPropertyReflector <NSObject>

- (JSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName;

@end


@class JSObjectionInjector;

extern const struct JSObjectionUtils {
    JSObjectionPropertyInfo (*findClassOrProtocolForProperty)(objc_property_t property);
    objc_property_t (*propertyForClass)(Class klass, NSString *propertyName);
    NSSet* (*buildDependenciesForClass)(Class klass, NSSet *requirements);
    NSDictionary* (*buildNamedDependenciesForClass)(Class klass, NSDictionary *namedRequirements);
    NSDictionary* (*buildInitializer)(SEL selector, NSArray *arguments);
    NSArray* (*transformVariadicArgsToArray)(va_list va_arguments);
    id (*buildObjectWithInitializer)(Class klass, SEL initializer, NSArray *arguments);
    void (*injectDependenciesIntoProperties)(JSObjectionInjector *injector, Class klass, id object);
} JSObjectionUtils;
