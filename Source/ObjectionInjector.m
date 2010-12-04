#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"

static NSMutableDictionary *gAOContext;

@implementation ObjectionInjector

+ (void)initialize {
  if (self == [ObjectionInjector class]) {
		gAOContext = [[NSMutableDictionary alloc] init];
  }
}

+ (void) registerObject:(id)theObject forClass:(Class)theClass {
  [gAOContext setObject:[[[ObjectionInstanceEntry alloc] initWithObject:theObject] autorelease] forKey:NSStringFromClass(theClass)];
}

+ (void) registerClass:(Class)theClass lifeCycle:(ObjectionInstantiationRule)lifeCycle {
  if (lifeCycle != ObjectionInstantiationRule_Singleton && lifeCycle != ObjectionInstantiationRule_Everytime) {
    @throw [NSException exceptionWithName:@"ObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
  }
  
  if (theClass && [gAOContext objectForKey:NSStringFromClass(theClass)] == nil) {
   [gAOContext setObject:[ObjectionEntry withClass:theClass lifeCycle:lifeCycle andContext:self] forKey:NSStringFromClass(theClass)];
  } 
}

+ (id)getObject:(Class)theClass {
  NSString *key = NSStringFromClass(theClass);
  ObjectionEntry *entry = [gAOContext objectForKey:key];
  if (theClass && entry) {
    return [entry extractObject];
  } 
  
  return nil;
}

+ (void) reset {
  [gAOContext removeAllObjects];
}
@end
