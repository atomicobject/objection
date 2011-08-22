#import "JSObjectionInjectorEntry.h"
#import "JSObjection.h"
#import "JSObjectionUtils.h"

@interface JSObjectionInjectorEntry()
- (void)notifyObjectThatItIsReady: (id)object;
- (id)buildObject;
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

- (id)extractObject 
{
  if (self.lifeCycle == JSObjectionInstantiationRuleNormal) {
  	return [self buildObject];  
  } else if (!_storageCache) {
    _storageCache = [[self buildObject] retain];
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

- (void)notifyObjectThatItIsReady: (id) object 
{
  if([object respondsToSelector:@selector(awakeFromObjection)]) {
    [object performSelector:@selector(awakeFromObjection)];
  }
}

- (id)buildObject 
{
	if([self.classEntry respondsToSelector:@selector(objectionRequires)]) {
    NSArray *properties = [self.classEntry performSelector:@selector(objectionRequires)];
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
  	id objectUnderConstruction = [[[self.classEntry alloc] init] autorelease];
    
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
    
    [self notifyObjectThatItIsReady: objectUnderConstruction];
    
    return objectUnderConstruction;
  } else {
    id object = [[[self.classEntry alloc] init] autorelease];
    [self notifyObjectThatItIsReady: object];
    return object;
  }
  
}

#pragma mark Class Methods
#pragma mark -

+ (id)entryWithClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)theLifeCycle 
{
  return [[[JSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle] autorelease];
}

+ (id)entryWithEntry:(JSObjectionInjectorEntry *)entry 
{
  return [[[JSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle] autorelease];  
}
@end
