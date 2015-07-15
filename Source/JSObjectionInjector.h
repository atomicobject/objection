#import <Foundation/Foundation.h>
#import "JSObjectionModule.h"

@interface JSObjectionInjector : NSObject 

- (instancetype)initWithContext:(NSDictionary *)theGlobalContext;
- (instancetype)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule;
- (instancetype)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)theModules;
- (id)getObject:(id)classOrProtocol;
- (id)getObject:(id)classOrProtocol named:(NSString*)name;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(id)classOrProtocol namedWithArgs:(NSString*)name, ... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(id)classOrProtocol arguments:(va_list)argList;
- (id)getObject:(id)classOrProtocol named:(NSString*)name arguments:(va_list)argList;
- (id)getObject:(id)classOrProtocol argumentList:(NSArray *)argumentList;
- (id)getObject:(id)classOrProtocol initializer:(SEL)selector argumentList:(NSArray *)argumentList;
- (id)getObject:(id)classOrProtocol named:(NSString*)name argumentList:(NSArray *)argumentList;
- (id)getObject:(id)classOrProtocol named:(NSString*)name initializer:(SEL)selector argumentList:(NSArray *)argumentList;
- (id)withModule:(JSObjectionModule *)theModule;
- (id)withModules:(JSObjectionModule *)first, ... NS_REQUIRES_NIL_TERMINATION;
- (id)withModuleCollection:(NSArray *)theModules;
- (id)withoutModuleOfType:(Class)moduleClass;
- (id)withoutModuleOfTypes:(Class)first, ... NS_REQUIRES_NIL_TERMINATION;
- (id)withoutModuleCollection:(NSArray *)moduleClasses;
- (void)injectDependencies:(id)object;
- (id)objectForKeyedSubscript: (id)key;
- (NSArray *)modules;

@end
