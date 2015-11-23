#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@protocol JSObjectionInjectorEntrySelectors

@optional
+ (id)objectionInitializer;

@end

@interface JSObjectionInjectorEntry : JSObjectionEntry

@property (nonatomic, readonly) Class classEntry;

- (instancetype)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle;
+ (instancetype)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle;

@end
