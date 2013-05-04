#import <Foundation/Foundation.h>

typedef enum {
      JSObjectionScopeNone = -1,
      JSObjectionScopeNormal,
      JSObjectionScopeSingleton  
} JSObjectionScope;


@class JSObjectionInjector, JSObjectionEntry;

@protocol JSObjectionEntry<NSObject>
@property (nonatomic, readonly) JSObjectionScope lifeCycle;
@property (nonatomic, assign) JSObjectionInjector *injector;
- (id)extractObject:(NSArray *)arguments;
+ (id)entryWithEntry:(JSObjectionEntry *)entry;
@end

@interface JSObjectionEntry : NSObject<JSObjectionEntry>
{
}

@end
