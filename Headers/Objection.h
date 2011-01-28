#import <Foundation/Foundation.h>

#import "ObjectionModule.h"
#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"
#import "NSObject+Objection.h"
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
  + (NSSet *)objectionRequires { \
      NSSet *requirements = [NSSet setWithObjects: args, nil]; \
      Class superClass = class_getSuperclass([self class]); \
      if([superClass respondsToSelector:@selector(objectionRequires)]) { \
        NSSet *parentsRequirements = [superClass performSelector:@selector(objectionRequires)]; \
        NSMutableSet *dependencies = [NSMutableSet setWithCapacity:parentsRequirements.count]; \
        [dependencies unionSet:parentsRequirements]; \
        [dependencies unionSet:requirements]; \
        requirements = dependencies; \
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
