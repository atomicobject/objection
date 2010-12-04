#import <Foundation/Foundation.h>

typedef enum {
  ObjectionInstantiationRule_Everytime,
  ObjectionInstantiationRule_Singleton  
} ObjectionInstantiationRule;


@interface ObjectionEntry : NSObject {
	Class _classEntry;
  ObjectionInstantiationRule _lifeCycle;
  id _context;
  id _storageCache;
}

@property(nonatomic, readonly) Class classEntry;
@property(nonatomic, readonly) ObjectionInstantiationRule lifeCycle;

- (id) initWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle andContext:(id)theContext;
- (id) extractObject;

+ (id)withClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle andContext:(id)theContext;
@end
