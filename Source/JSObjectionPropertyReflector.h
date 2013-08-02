#import <Foundation/Foundation.h>
#import "JSObjectionUtils.h"

@interface JSObjectionPropertyReflector : NSObject
+ (JSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName;
@end
