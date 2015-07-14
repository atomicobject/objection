#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionInjectorEntry : JSObjectionEntry

@property (nonatomic, readonly) Class classEntry;

- (instancetype)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle;
+ (instancetype)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle;

@end
