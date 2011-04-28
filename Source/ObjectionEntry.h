#import <Foundation/Foundation.h>

typedef enum {
  ObjectionInstantiationRuleNone = -1,
  ObjectionInstantiationRuleEverytime,
  ObjectionInstantiationRuleSingleton  
} ObjectionInstantiationRule;


@class ObjectionInjector, ObjectionEntry;

@protocol ObjectionEntry<NSObject>
@property (nonatomic, readonly) ObjectionInstantiationRule lifeCycle;
@property (nonatomic, assign) ObjectionInjector *injector;
- (id)extractObject;
+ (id)entryWithEntry:(ObjectionEntry *)entry;
@end

@interface ObjectionEntry : NSObject<ObjectionEntry>
{
  id _injector;  
}

@end
