#import <Foundation/Foundation.h>
#import "ObjectionModule.h"
#import "ObjectionInjector.h"
#import "ObjectionEntry.h"
#import <objc/objc.h>
#import <objc/runtime.h>

#define objection_register(value)			\
  + (void)initialize { \
    if (self == [value class]) { \
      [Objection registerClass:[value class] lifeCycle: ObjectionInstantiationRule_Everytime]; \
    } \
  }

#define objection_register_singleton(value) \
  + (void)initialize { \
      if (self == [value class]) { \
        [Objection registerClass:[value class] lifeCycle: ObjectionInstantiationRule_Singleton]; \
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

@interface Objection : NSObject {

}

+ (ObjectionInjector *) createInjector:(ObjectionModule *)aModule;
+ (ObjectionInjector *) createInjector;
+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle;
+ (void)setGlobalInjector:(ObjectionInjector *)anInjector;
+ (ObjectionInjector *) globalInjector;
+ (void) reset;
@end
