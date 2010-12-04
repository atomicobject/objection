#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"

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
	+ (NSArray *)requires { \
		return [NSArray arrayWithObjects: args, nil]; \
	} \

@interface ObjectionInjector : NSObject {

}

+ (void) registerObject:(id)theObject forClass:(Class)theClass;
+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle;
+ (id) getObject:(Class)theClass;
+ (void) reset;
@end
