#import <Foundation/Foundation.h>
#import "JSObjectionModule.h"

@interface JSObjectionInjector : NSObject {
      NSDictionary *_globalContext;
      NSMutableDictionary *_context;
      NSMutableSet *_eagerSingletons;
      NSMutableDictionary *_modules;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(JSObjectionModule *)theModule;
- (id)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)modules;
- (id)getObject:(id)classOrProtocol;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(id)classOrProtocol arguments:(va_list)argList;
- (id)objectForKeyedSubscript: (id)key;

- (void)addModule:(JSObjectionModule *)module;
- (void)addModules:(NSArray *)modules;
- (void)removeModule:(Class)aClass;
- (void)removeAllModules;
- (BOOL)hasModule:(Class)aClass;

- (void)dumpContext;
@end
