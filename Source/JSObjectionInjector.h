#import <Foundation/Foundation.h>
#import "JSObjectionModule.h"

@interface JSObjectionInjector : NSObject {
    NSDictionary *_globalContext;
    NSMutableDictionary *_context;
    NSSet *_eagerSingletons;
    NSMutableArray *_modules;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)theModules;
- (id)getObject:(id)classOrProtocol;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(id)classOrProtocol arguments:(va_list)argList;
- (id)getObject:(id)classOrProtocol argumentList:(NSArray *)argumentList;
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
