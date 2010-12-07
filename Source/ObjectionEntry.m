#import "ObjectionEntry.h"
#import "Objection.h"

#import <objc/runtime.h>

@interface ObjectionEntry (Private)
- (void) notifyObjectThatItIsReady: (id)object;
- (Class) parseClassFromProperty:(objc_property_t)property;
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
    _storageCache = [self buildObject];
  }
  
  return _storageCache;
}

- (void)dealloc {
  [_storageCache release]; _storageCache = nil;
  [super dealloc];
}

#pragma mark NSCopying
#pragma mark -

- (id)copyWithZone:(NSZone *)zone {
  return [[ObjectionEntry alloc] initWithClass:self.classEntry lifeCycle:self.lifeCycle];
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
  	id objectUnderConstruction = [[self.classEntry alloc] init];
    
    for (NSString *propertyName in properties) {
      objc_property_t property = class_getProperty(self.classEntry, (const char *)[propertyName UTF8String]);
      if (property == NULL) {
        @throw [NSException exceptionWithName:@"ObjectionInjectionException" reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
      }
      
      Class desiredClass = [self parseClassFromProperty:property];
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

+ (id)withClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle {
  return [[[ObjectionEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle] autorelease];
}

#pragma mark Private Methods

- (Class)parseClassFromProperty:(objc_property_t)property {
  NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];  
  NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
  
  NSRange startRange = [attributes rangeOfString:@"T@\""];
  if (startRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:@"ObjectionInjectionException" reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
  }
  
  NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
  NSRange endRange = [startOfClassName rangeOfString:@"\""];
  
  if (endRange.location == NSNotFound) {
    @throw [NSException exceptionWithName:@"ObjectionInjectionException" reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];        
  }
  
  NSString *className = [startOfClassName substringToIndex:endRange.location];
  Class theClass = NSClassFromString(className);
  
  if(!theClass) {
    @throw [NSException exceptionWithName:@"ObjectionInjectionException" reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", className, propertyName] userInfo:nil];            
  }
  
  return theClass;    
}
@end
