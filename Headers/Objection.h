#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

#import "ObjectionModule.h"
#import "ObjectionInjector.h"
#import "ObjectionEntry.h"
#import "ObjectionBindingEntry.h"
#import "NSObject+Objection.h"
#import "ObjectionInjectorEntry.h"
#import "ObjectionFunctions.h"

#define objection_register(value)			\
  + (void)initialize { \
    if (self == [value class]) { \
      [Objection registerClass:[value class] lifeCycle: ObjectionInstantiationRuleEverytime]; \
    } \
  }

#define objection_register_singleton(value) \
  + (void)initialize { \
      if (self == [value class]) { \
        [Objection registerClass:[value class] lifeCycle: ObjectionInstantiationRuleSingleton]; \
      } \
    }

#define objection_requires(args...) \
  + (NSSet *)objectionRequires { \
      NSSet *requirements = [NSSet setWithObjects: args, nil]; \
      return ObjectionBuildDependenciesForClass(self, requirements); \
    } \

@interface Objection : NSObject {

}

+ (ObjectionInjector *)createInjector:(ObjectionModule *)aModule;
+ (ObjectionInjector *)createInjector;
+ (void)registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle;
+ (void)setGlobalInjector:(ObjectionInjector *)anInjector;
+ (ObjectionInjector *)globalInjector;
+ (void)reset;
@end
