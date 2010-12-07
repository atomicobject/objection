#import <Foundation/Foundation.h>

typedef enum {
  ObjectionInstantiationRule_Everytime,
  ObjectionInstantiationRule_Singleton  
} ObjectionInstantiationRule;


@class ObjectionInjector;

@interface ObjectionEntry : NSObject<NSCopying> {
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

+ (id)withClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle;
@end
