#import "JSObjectionInjectorEntry.h"
#import "JSObjection.h"
#import "JSObjectionUtils.h"
#import "NSObject+Objection.h"

@interface JSObjectionInjectorEntry()
- (id)buildObject:(NSArray *)arguments;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;
@end


@implementation JSObjectionInjectorEntry
@synthesize lifeCycle = _lifeCycle; 
@synthesize classEntry = _classEntry;

#pragma mark Instance Methods
#pragma mark -

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle 
{
  if ((self = [super init])) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
  }
  
  return self;
}

- (id)extractObject:(NSArray *)arguments {
  if (self.lifeCycle == JSObjectionScopeNormal || !_storageCache) {
      return [self buildObject:arguments];  
  }
  
  return _storageCache;
}

- (void)dealloc 
{
   _storageCache = nil;
}


#pragma mark -
#pragma mark Private Methods

- (id)buildObject:(NSArray *)arguments {
    
    id objectUnderConstruction = nil;
    if ([self.classEntry respondsToSelector:@selector(objectionInitializer)]) {
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

#pragma mark Class Methods
#pragma mark -

+ (id)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle  {
    return [[JSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle];
}

+ (id)entryWithEntry:(JSObjectionInjectorEntry *)entry {
    return [[JSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle];  
}
@end
