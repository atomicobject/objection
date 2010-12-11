#import "ObjectionEntry.h"
#import "Objection.h"
#import "ObjectionFunctions.h"

@interface ObjectionEntry (Private)
- (void) notifyObjectThatItIsReady: (id)object;
- (id) buildObject;
@end


@implementation ObjectionEntry
@synthesize lifeCycle=_lifeCycle; 
@synthesize classEntry=_classEntry;
@synthesize injector=_injector;

#pragma mark Instance Methods
#pragma mark -

- (id)initWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle {
  if (self = [super init]) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
  }
  
  return self;
}

- (id) extractObject {
  if (self.lifeCycle == ObjectionInstantiationRule_Everytime) {
  	return [self buildObject];  
  } else if (!_storageCache) {
    _storageCache = [[self buildObject] retain];
  }
  
  return _storageCache;
}

- (void)dealloc {
  [_storageCache release]; _storageCache = nil;
  [super dealloc];
}

#pragma mark Private Methods
#pragma mark -

- (void) notifyObjectThatItIsReady: (id) object  {
  if([object respondsToSelector:@selector(awakeFromObjection)]) {
    [object performSelector:@selector(awakeFromObjection)];
  }
}

- (id)buildObject {
	if([self.classEntry respondsToSelector:@selector(objectionRequires)]) {
    NSArray *properties = [self.classEntry performSelector:@selector(objectionRequires)];
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
  	id objectUnderConstruction = [[[self.classEntry alloc] init] autorelease];
    
    for (NSString *propertyName in properties) {
      objc_property_t property = ObjectionGetProperty(self.classEntry, propertyName);
      Class desiredClass = ObjectionFindClassForProperty(property);
      // Ensure that the class is initialized before attempting to retrieve it.
      // Using +load would force all registered classes to be initialized so we are
      // lazily initializing them.
      [desiredClass class];
      
      id theObject = [_injector getObject:desiredClass];
      
      if(!theObject) {
        [Objection registerClass:desiredClass lifeCycle: ObjectionInstantiationRule_Everytime];
        theObject = [_injector getObject:desiredClass];
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

+ (id)entryWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle {
  return [[[ObjectionEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle] autorelease];
}

+ (id)entryWithEntry:(ObjectionEntry *)entry {
  return [[[ObjectionEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle] autorelease];  
}
@end
