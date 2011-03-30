#import <Foundation/Foundation.h>
#import "ObjectionEntry.h"

@interface ObjectionInjectorEntry : ObjectionEntry {
	Class _classEntry;
  ObjectionInstantiationRule _lifeCycle;
  id _storageCache;
}

@property (nonatomic, readonly) Class classEntry;
@property (nonatomic, readonly) ObjectionInstantiationRule lifeCycle;

- (id)initWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle;
+ (id)entryWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle;
@end
