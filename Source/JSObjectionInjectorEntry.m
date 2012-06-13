#import "JSObjectionInjectorEntry.h"
#import "JSObjection.h"
#import "JSObjectionUtils.h"

@interface JSObjectionInjectorEntry()
- (void)notifyObjectThatItIsReady: (id)object;
- (id)buildObject:(NSArray *)arguments;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;
@end


@implementation JSObjectionInjectorEntry
@synthesize lifeCycle = _lifeCycle; 
@synthesize classEntry = _classEntry;

#pragma mark Instance Methods
#pragma mark -

- (id)initWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle 
{
  if ((self = [super init])) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
  }
  
  return self;
}

- (id)extractObject:(NSArray *)arguments {
  if (self.lifeCycle == JSObjectionInstantiationRuleNormal || !_storageCache) {
      return [self buildObject:arguments];  
  }
  
  return _storageCache;
}

- (void)dealloc 
{
  [_storageCache release]; _storageCache = nil;
  [super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void)notifyObjectThatItIsReady:(id)object {
  if([object respondsToSelector:@selector(awakeFromObjection)]) {
    [object performSelector:@selector(awakeFromObjection)];
  }
}

- (id)buildObject:(NSArray *)arguments {
    
    id objectUnderConstruction = nil;    
    if ([self.classEntry respondsToSelector:@selector(objectionInitializer)]) {
        objectUnderConstruction = JSObjectionUtils.buildObjectWithInitializer(self.classEntry, [self initializerForObject], [self argumentsForObject:arguments]);
    } else {
        objectUnderConstruction = [[[self.classEntry alloc] init] autorelease];
    }

    if (self.lifeCycle == JSObjectionInstantiationRuleSingleton) {
        _storageCache = [objectUnderConstruction retain];
    }

    if ([self.classEntry respondsToSelector:@selector(objectionRequires)]) {
      NSArray *properties = [self.classEntry performSelector:@selector(objectionRequires)];
      NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];

        for (NSString *propertyName in properties) {
            objc_property_t property = JSObjectionUtils.propertyForClass(self.classEntry, propertyName);
            JSObjectionPropertyInfo propertyInfo = JSObjectionUtils.findClassOrProtocolForProperty(property);
            id desiredClassOrProtocol = propertyInfo.value;
            // Ensure that the class is initialized before attempting to retrieve it.
            // Using +load would force all registered classes to be initialized so we are
            // lazily initializing them.
            if (propertyInfo.type == JSObjectionTypeClass) {
                [desiredClassOrProtocol class];        
            }

            id theObject = [self.injector getObject:desiredClassOrProtocol];

            if(theObject == nil && propertyInfo.type == JSObjectionTypeClass) {
                [JSObjection registerClass:desiredClassOrProtocol lifeCycle: JSObjectionInstantiationRuleNormal];
                theObject = [_injector getObject:desiredClassOrProtocol];
            } else if (!theObject) {
                @throw [NSException exceptionWithName:@"JSObjectionException" 
                                               reason:[NSString stringWithFormat:@"Cannot find an instance that is bound to the protocol '%@' to assign to the property '%@'", NSStringFromProtocol(desiredClassOrProtocol), propertyName] 
                                             userInfo:nil];
            }
            
            [propertiesDictionary setObject:theObject forKey:propertyName];      
        }
        
        [objectUnderConstruction setValuesForKeysWithDictionary:propertiesDictionary];
    }

    [self notifyObjectThatItIsReady: objectUnderConstruction];
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

+ (id)entryWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle  {
    return [[[JSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle] autorelease];
}

+ (id)entryWithEntry:(JSObjectionInjectorEntry *)entry {
    return [[[JSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle] autorelease];  
}
@end
