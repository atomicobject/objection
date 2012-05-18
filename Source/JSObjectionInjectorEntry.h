#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionInjectorEntry : JSObjectionEntry {
	Class _classEntry;
    JSObjectionInstantiationRule _lifeCycle;
    id _storageCache;
}

@property (nonatomic, readonly) Class classEntry;

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle;
+ (id)entryWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle;
@end
