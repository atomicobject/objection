#import "JSObjectionRuntimePropertyReflector.h"

@implementation JSObjectionRuntimePropertyReflector
- (JSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName {
    objc_property_t property = JSObjectionUtils.propertyForClass(theClass, propertyName);
    return JSObjectionUtils.findClassOrProtocolForProperty(property);    
}
@end
