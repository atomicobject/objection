#import <Foundation/Foundation.h>

typedef enum {
      JSObjectionInstantiationRuleNone = -1,
      JSObjectionInstantiationRuleNormal,
      JSObjectionInstantiationRuleSingleton  
} JSObjectionInstantiationRule;


@class JSObjectionInjector, JSObjectionEntry;

@protocol JSObjectionEntry<NSObject>
@property (nonatomic, readonly) JSObjectionInstantiationRule lifeCycle;
@property (nonatomic, assign) JSObjectionInjector *injector;
- (id)extractObject:(NSArray *)arguments;
+ (id)entryWithEntry:(JSObjectionEntry *)entry;
@end

@interface JSObjectionEntry : NSObject<JSObjectionEntry>
{
    id _injector;  
}

@end
