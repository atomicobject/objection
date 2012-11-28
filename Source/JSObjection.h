#import <Foundation/Foundation.h>
#import "JSObjectionInjector.h"
#import "JSObjectionEntry.h"

@interface JSObjection : NSObject

+ (JSObjectionInjector *)createInjector;
+ (void)setDefaultInjector:(JSObjectionInjector *)anInjector;
+ (JSObjectionInjector *)defaultInjector;
@end
