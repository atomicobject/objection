#import <Foundation/Foundation.h>


@interface JSObjectionDependency : NSObject
@property (readonly, assign) id dependentType;
+ (JSObjectionDependency *) for:(id)classOrProtocol;
@end