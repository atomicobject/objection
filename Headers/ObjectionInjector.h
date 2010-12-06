#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"
#import <objc/objc.h>
#import <objc/runtime.h>

#define objection_register(value)			\
  + (void)initialize { \
    if (self == NSClassFromString(value)) { \
      [ObjectionInjector registerClass:NSClassFromString(value) lifeCycle: ObjectionInstantiationRule_Everytime]; \
    } \
  }

#define objection_register_singleton(value) \
  + (void)initialize { \
    if (self == NSClassFromString(value)) { \
      [ObjectionInjector registerClass:NSClassFromString(value) lifeCycle: ObjectionInstantiationRule_Singleton]; \
    } \
  }

#define objection_requires(args...) \
	+ (NSArray *)objectionRequires { \
    NSArray *requirements = [NSArray arrayWithObjects: args, nil]; \
    Class superClass = class_getSuperclass([self class]); \
    if([superClass respondsToSelector:@selector(objectionRequires)]) { \
      NSArray *parentsRequirements = [superClass performSelector:@selector(objectionRequires)]; \
      NSMutableSet *dependencies = [NSMutableSet setWithCapacity:parentsRequirements.count]; \
      [dependencies addObjectsFromArray:parentsRequirements]; \
      [dependencies addObjectsFromArray:requirements]; \
      requirements = [dependencies allObjects]; \
    } \
		return requirements; \
	} \

@interface ObjectionInjector : NSObject {

}

+ (void) registerObject:(id)theObject forClass:(Class)theClass;
+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle;
+ (id) getObject:(Class)theClass;
+ (void) reset;
@end
