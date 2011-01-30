#import <Foundation/Foundation.h>

typedef enum {
  ObjectionInstantiationRuleEverytime,
  ObjectionInstantiationRuleSingleton  
} ObjectionInstantiationRule;


@protocol ObjectionEntry<NSObject>

@property(nonatomic, readonly) ObjectionInstantiationRule lifeCycle;

- (id) extractObject;

@end


@class ObjectionInjector;

@interface ObjectionEntry : NSObject {
	Class _classEntry;
  ObjectionInstantiationRule _lifeCycle;
  id _injector;
  id _storageCache;
}

@property(nonatomic, readonly) Class classEntry;
@property(nonatomic, readonly) ObjectionInstantiationRule lifeCycle;
@property(nonatomic, assign) ObjectionInjector *injector;

- (id) initWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle;
- (id) extractObject;

+ (id)entryWithEntry:(ObjectionEntry *)entry;
+ (id)entryWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle;
@end
