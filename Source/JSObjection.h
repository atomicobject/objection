#import <Foundation/Foundation.h>
#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectionUtils.h"

@interface JSObjection : NSObject

+ (JSObjectionInjector *)createInjectorWithModules:(JSObjectionModule *)first, ... NS_REQUIRES_NIL_TERMINATION;
+ (JSObjectionInjector *)createInjectorWithModulesArray:(NSArray *)modules;
+ (JSObjectionInjector *)createInjector:(JSObjectionModule *)module;
+ (JSObjectionInjector *)createInjector;
+ (void)registerClass:(Class)theClass scope:(JSObjectionScope)scope;
+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector;
+ (JSObjectionInjector *)defaultInjector;
+ (void)reset;
+ (JSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName;
+ (void)setPropertyReflector:(Class)reflector;

@end
