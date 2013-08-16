#import <Foundation/Foundation.h>

@class JSObjectionInjector;

@interface JSObjectFactory : NSObject
@property (nonatomic, readonly, weak) JSObjectionInjector *injector;

- (id)initWithInjector:(JSObjectionInjector *)injector;
- (id)getObject:(id)classOrProtocol;
- (id)getObject:(id)classOrProtocol withArgumentList:(NSArray *)arguments;
- (id)objectForKeyedSubscript: (id)key;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;
@end
