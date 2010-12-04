#import "ObjectionEntry.h"
#import <objc/runtime.h>

static Class ParseClassFromProperty(objc_property_t property) {
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

@interface ObjectionEntry (Private)
- (void) notifyObjectThatItIsReady: (id)object;
@end


@implementation ObjectionEntry
@synthesize lifeCycle=_lifeCycle, classEntry=_classEntry;

#pragma mark Instance Methods
#pragma mark -

- (id)initWithClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle andContext:(id)theContext {
  if (self = [super init]) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
    _context = [theContext retain];
  }
  
  return self;
}


- (id)buildObject {
	if([self.classEntry respondsToSelector:@selector(requires)]) {
    NSArray *properties = [self.classEntry performSelector:@selector(requires)];
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
  	id objectUnderConstruction = [[self.classEntry alloc] init];
    
    for (NSString *propertyName in properties) {
      objc_property_t property = class_getProperty(self.classEntry, (const char *)[propertyName UTF8String]);
      if (property == NULL) {
        @throw [NSException exceptionWithName:@"ObjectionInjectionException" reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
      }
      
      Class desiredClass = ParseClassFromProperty(property);
      id theObject = [_context performSelector:@selector(getObject:) withObject:desiredClass];
      
      if(!theObject) {
        [_context performSelector:@selector(registerClass:lifeCycle:) withObject:desiredClass withObject:ObjectionInstantiationRule_Everytime];
        theObject = [_context performSelector:@selector(getObject:) withObject:desiredClass];
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

- (id) extractObject {
  if (self.lifeCycle == ObjectionInstantiationRule_Everytime) {
  	return [self buildObject];  
  } else if (!_storageCache) {
    _storageCache = [self buildObject];
  }
  
  return _storageCache;
}

- (void)dealloc {
  [_context release]; _context = nil;
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

#pragma mark Class Methods
#pragma mark -

+ (id)withClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)theLifeCycle andContext:(id)theContext {
  return [[[ObjectionEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle andContext:theContext] autorelease];
}

@end
