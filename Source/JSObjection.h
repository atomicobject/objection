#import <Foundation/Foundation.h>
#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"

@interface JSObjection : NSObject {
    
}

+ (JSObjectionInjector *)createInjectorWithModules:(JSObjectionModule *)first, ... NS_REQUIRES_NIL_TERMINATION;
+ (JSObjectionInjector *)createInjector:(JSObjectionModule *)module;
+ (JSObjectionInjector *)createInjector;
+ (void)registerClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)lifeCycle;
+ (void)unRegisterClass:(Class)theClass;
+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector;
+ (JSObjectionInjector *)defaultInjector;
+ (void)reset;

+ (void)dumpContext;

+ (BOOL)hasEntryForClass:(Class)aClass;
@end
