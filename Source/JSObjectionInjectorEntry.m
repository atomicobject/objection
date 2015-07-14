#import "JSObjectionInjectorEntry.h"
#import "JSObjection.h"
#import "JSObjectionUtils.h"
#import "NSObject+Objection.h"

@interface JSObjectionInjectorEntry() {
  JSObjectionScope _lifeCycle;
  id _storageCache;
}

- (id)buildObject:(NSArray *)arguments initializer:(SEL)initializer;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;

@end


@implementation JSObjectionInjectorEntry

@synthesize lifeCycle = _lifeCycle;
@synthesize classEntry = _classEntry;


#pragma mark - Instance Methods

- (instancetype)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle {
  if ((self = [super init])) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
  }
  
  return self;
}

- (instancetype) extractObject:(NSArray *)arguments initializer:(SEL)initializer {
    if (self.lifeCycle == JSObjectionScopeNormal || !_storageCache) {
        return [self buildObject:arguments initializer: initializer];
    }
    return _storageCache;
}

- (instancetype)extractObject:(NSArray *)arguments {
    return [self extractObject:arguments initializer:nil];
}

- (void)dealloc  {
   _storageCache = nil;
}


#pragma mark - Private Methods

- (id)buildObject:(NSArray *)arguments initializer: (SEL) initializer {
    
    id objectUnderConstruction = nil;
    
    if(initializer != nil) {
        objectUnderConstruction = JSObjectionUtils.buildObjectWithInitializer(self.classEntry, initializer, arguments);
    } else if ([self.classEntry respondsToSelector:@selector(objectionInitializer)]) {
        objectUnderConstruction = JSObjectionUtils.buildObjectWithInitializer(self.classEntry, [self initializerForObject], [self argumentsForObject:arguments]);
    } else {
        objectUnderConstruction = [[self.classEntry alloc] init];
    }

    if (self.lifeCycle == JSObjectionScopeSingleton) {
        _storageCache = objectUnderConstruction;
    }
    
    JSObjectionUtils.injectDependenciesIntoProperties(self.injector, self.classEntry, objectUnderConstruction);
    
    return objectUnderConstruction;
}

- (SEL)initializerForObject {
    return NSSelectorFromString([[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:JSObjectionInitializerKey]);
}

- (NSArray *)argumentsForObject:(NSArray *)givenArguments {
    return givenArguments.count > 0 ? givenArguments : [[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:JSObjectionDefaultArgumentsKey];
}


#pragma mark - Class Methods

+ (id)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle  {
    return [[JSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle];
}

+ (id)entryWithEntry:(JSObjectionInjectorEntry *)entry {
    return [[JSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle];  
}
@end
