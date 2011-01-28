#import "ObjectionInjector.h"
#import "ObjectionInstanceEntry.h"
#import "ObjectionEntry.h"
#import <pthread.h>
#import <objc/runtime.h>

@interface ObjectionInjector(Private)
- (void)configureContext;
@end

@implementation ObjectionInjector

- (id)initWithContext:(NSDictionary *)theGlobalContext {
  if ((self = [super init])) {
    _globalContext = [theGlobalContext retain];
    _context = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

- (id)initWithContext:(NSDictionary *)theGlobalContext andModule:(ObjectionModule *)theModule {
  if (self = [self initWithContext:theGlobalContext]) {
    [theModule configure];
    [_context addEntriesFromDictionary:theModule.bindings];
  }
  return self;
}

- (id)getObject:(id)classOrProtocol {
  @synchronized(self) {
    
    if (!classOrProtocol) {
      return nil;
    }
    
    /*
     We have not found an effective programmatic method of determining whether an object is a Class or Protocol. A Protocol appears
     to act like a root level object where the superclass is itself. It does not implement methodSignatureForSelector: that the root object NSObject
     and NSProxy implement. Therefore we are using this as a distinguishing factor in whether to treat it like a protocol or class.
    */
    NSString *key = nil;
    if ([classOrProtocol respondsToSelector:@selector(methodSignatureForSelector:)]) {
      key = NSStringFromClass(classOrProtocol);
    } else {
      key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
    }

    
    id<ObjectionEntry> injectorEntry = [_context objectForKey:key];
    
    if (!injectorEntry) {
      id<ObjectionEntry> entry = [_globalContext objectForKey:key];
      if ([entry isKindOfClass:[ObjectionEntry class]]) {
        injectorEntry = [ObjectionEntry entryWithEntry:entry];
        ((ObjectionEntry *)injectorEntry).injector = self;
        [_context setObject:injectorEntry forKey:key];      
      }
    }
    
    if (classOrProtocol && injectorEntry) {
      return [injectorEntry extractObject];
    } 
    
    return nil;    
  }
}

- (void)dealloc {
  [_globalContext release]; _globalContext = nil;
  [_context release]; _context = nil;  
  [super dealloc];
}

@end
