#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionInjectorEntry : JSObjectionEntry {
    JSObjectionScope _lifeCycle;
    id _storageCache;
}

@property (nonatomic, readonly) Class classEntry;

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle;
+ (id)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle;
@end
