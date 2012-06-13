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
        NSSet *requirements = [NSSet setWithObjects: args, nil]; \
        return JSObjectionUtils.buildDependenciesForClass(self, requirements); \
    }

#define objection_initializer(selectorSymbol, args...) \
    + (NSDictionary *)objectionInitializer { \
        id objs[]= {args}; \
        NSArray *defaultArguments = [NSArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
        return JSObjectionUtils.buildInitializer(@selector(selectorSymbol), defaultArguments); \
    }
    