#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionInjectorEntry : JSObjectionEntry

@property (nonatomic, readonly) Class classEntry;

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle;
+ (id)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle;

@end
