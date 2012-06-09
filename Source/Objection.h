#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

#import "JSObjectionModule.h"
#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"
#import "JSObjectionBindingEntry.h"
#import "NSObject+Objection.h"
#import "JSObjectionInjectorEntry.h"
#import "JSObjectionUtils.h"
#import "JSObjectionProviderEntry.h"
#import "JSObjectFactory.h"
#import "JSObjection.h"

#define objection_register(value)			\
      + (void)initialize { \
        if (self == [value class]) { \
          [JSObjection registerClass:[value class] lifeCycle: JSObjectionInstantiationRuleNormal]; \
        } \
      }

#define objection_register_singleton(value) \
      + (void)initialize { \
          if (self == [value class]) { \
            [JSObjection registerClass:[value class] lifeCycle: JSObjectionInstantiationRuleSingleton]; \
          } \
        }

#define objection_requires(args...) \
  + (NSSet *)objectionRequires { \
      NSMutableSet *requirements = [NSMutableSet setWithObjects: args, nil]; \
      if ([super resolveClassMethod:@selector(objectionRequires)])  \
          [props unionSet:[super objectionRequires]];\
      return JSObjectionUtils.buildDependenciesForClass(self, requirements); \
    }
