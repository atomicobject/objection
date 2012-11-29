#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionInjectorEntry : JSObjectionEntry {
	Class _classEntry;
    JSObjectionInstantiationRule _lifeCycle;
    id _storageCache;
    NSMutableArray *_autoRegisteredClasses;
}

@property (nonatomic, readonly) Class classEntry;
@property (nonatomic, readonly) NSArray *autoRegisteredClasses;

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle;
+ (id)entryWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle;
@end
