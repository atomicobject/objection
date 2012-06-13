Description
===========

Objection is a lightweight dependency injection framework for Objective-C for MacOS X and iOS. For those of you that have used Guice objection will feel familiar. Objection was built to stay out of your way and alleviate the need to maintain a large XML container or manually construct objects.

Features
==============

* "Annotation" Based Dependency Injection
* Seamless support for integrating custom and external dependencies
  * Custom Object Providers
  * Meta Class Bindings
  * Protocol Bindings
  * Instance Bindings
* Lazily instantiates dependencies
* Eager Singletons
* Initializer Support
  * Default and custom arguments

Using Objection
========

### Basic Usage

A class can be registered with objection using the macros *objection_register* or *objection_register_singleton*. The *objection_requires* macro can be used to declare what dependencies objection should provide to all instances it creates of that class. *objection_requires* can be used safely with inheritance.

#### Example
```objective-c
@class Engine, Brakes;

@interface Car : NSObject
{
  Engine *engine;
  Brakes *brakes;
  BOOL awake;  
}

// Will be filled in by objection
@property(nonatomic, retain) Engine *engine;
// Will be filled in by objection
@property(nonatomic, retain) Brakes *brakes;
@property(nonatomic) BOOL awake;

@implementation Car
objection_register(Car)
objection_requires(@"engine", @"brakes")
@synthesize engine, brakes, awake;
@end
```
### Fetching Objects from Objection

An object can be fetched from objection by creating an injector and then asking for an instance of a particular class or protocol. An injector manages its own object context. Which means that a singleton is per injector and is not necessarily a *true* singleton.

```objective-c
- (void)someMethod {
  JSObjectionInjector *injector = [JSObjection createInjector];
  id car = [injector getObject:[Car class]];
}
```

A default injector can be registered with Objection which can be used throughout your application or library.

```objective-c    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  JSObjectionInjector *injector = [JSObjection createInjector];
  [JSObjection setDefaultInjector:injector];
}

- (void)viewDidLoad {
  id myModel = [[JSObjection defaultInjector] getObject:[MyModel class]];
}
```
### Awaking from Objection

If an object is interested in knowing when it has been fully instantiated by objection it can implement the method
*awakeFromObjection*.

#### Example
```objective-c
@implementation Car
//...
objection_register_singleton(Car)
  - (void)awakeFromObjection {
    awake = YES;
  }
@end  
```  
### Eager Singletons

You can mark registered singleton classes as eager singletons. Eager singletons will be instantiated during the creation of the injector rather than being lazily instantiated.

### Example
```objective-c
@implementation MyAppModule
- (void)configure {
  [self registerEagerSingleton:[Car class]];
}

@end
```  
### Object Factory

A class can get objects from the injector context through an object factory.

### Example
```objective-c
@interface RequestDispatcher
@property(nonatomic, retain) JSObjectFactory *objectFactory
@end

@implementation RequestDispatcher
- (void)dispatch:(NSDictionary *)params
{
  Request *request = [self.objectFactory getObject:[Request class]];
  request.params = params;
  [request send];
}
@end
```
### Integrating external dependencies

Objection supports associating an object outside the context of Objection by configuring an JSObjectionModule.

#### Instance and Protocol Bindings

* Bind a protocol or class to a specific instance of that type
* Bind a class that is registered with Objection to a protocol

#### Example
```objective-c
@interface MyAppModule : JSObjectionModule {
  
}
@end

@implementation MyAppModule
- (void)configure {
  [self bind:[UIApplication sharedApplication] toClass:[UIApplication class]];
  [self bind:[UIApplication sharedApplication].delegate toProtocol:@protocol(UIApplicationDelegate)];
  [self bindClass:[MyAPIService class] toProtocol:@protocol(APIService)];
}

@end
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  JSObjectionInjector *injector = [JSObjection createInjector:[[[MyAppModule alloc] init] autorelease]];
  [JSObjection setDefaultInjector:injector];
}
```
#### Meta Class Bindings

There are times when a dependency -- usually external -- is implemented using only class methods. Objection can explicitly support binding to
the meta class instance through a protocol. This avoids having to unnecessarily create a wrapper class that passes through to the class
methods. The catch, of course, is that it requires a protocol definition so that Objection knows how to bind the meta class to objects
in the injector context.

#### Example
```objective-c
@protocol ExternalUtility
  - (void)doSomething;
@end

@interface ExternalUtility
  + (void)doSomething;
@end

@implementation ExternalUtility
  + (void)doSomething {...}
@end

// Module Configuration
- (void)configure {
  [self bindMetaClass:[ExternalUtility class] toProtocol:@protocol(ExternalUtility)];    
}

@interface SomeClass
{
  ...
}
// Use 'assign' because a meta class is not subject to the normal retain/release lifecycle. 
// It will exist until the application is terminated (Class Initialization -> Application Termination)
// regardless of the number of objects in the runtime that reference it.
@property (nonatomic, assign) id<ExternalUtility> externalUtility
@end
```
#### Providers

Occasionally you'll want to manually construct an object within Objection. Providers allow you to use a custom mechanism for building objects that are bound to a type. You can create a class that _conforms_ to the ObjectionProvider protocol or you can use a _block_ to build the object.
      
#### Example
```objective-c
@implementation CarProvider
- (id)provide:(JSObjectionInjector *)context {
  // Manually build object
  return car;
}
@end

@implementation MyAppModule
- (void)configure {
    [self bindProvider:[[[CarProvider alloc] init] autorelease] toClass:[Car class]];
    [self bindBlock:^(JSObjectionInjector *context) {
      // Manually build object
      return car;          
    } toClass:[Car class]];
}
@end
```

#### Initializers

By default, Objection allocates objects with the default initializer <code>init</code>. If you'd like to instantiate an object with an alternate ininitializer the <code>objection_initializer</code> macro can be used to do so. The macro supports passing in default arguments (scalar values are not currently supported) as well.
      
#### Default Arguments Example
```objective-c
@implementation ViewController
objection_register(ViewController)
objection_initializer(initWithNibName:bundle:, @"ViewController")
@end
```

####  Custom Arguments Example
```objective-c
@implementation ConfigurableCar
objection_register(ConfigurableCar)
objection_requires(@"engine", @"brakes")
objection_initializer(initWithMake:model:)

@synthesize make;
@synthesize model;

- (id)initWithMake:(NSString *)make model:(NSString *)model {
  ...
}
@end

- (void)buildCar {
  ConfigurableCar *car = [self.objectFactory getObjectWithArgs:[ConfigurableCar class], @"VW", @"Passat", nil];
  NSLog(@"Make: %@ Model: %@", car.make, car.model);
}
```

## TODO

* ARCify for iOS
* Pass along arguments to providers

Installation
=======

Download the latest [here](https://github.com/atomicobject/objection/downloads) __or__

    git clone git://github.com/atomicobject/objection.git
    git checkout 0.12.0
    
### iOS


1. rake artifact:ios
2. cp -R build/Release-iphoneuniversal/Objection-iOS.framework ${DEST_DIR}
3. In XCode -> Project Icon -> Your Target -> Build Phases -> Link Binary With Libraries -> Add (+) -> Add Other
4. Add -ObjC and -all_load to Other Link Flags in your project

#### Include framework
    #import <Objection-iOS/Objection.h>

### MacOS X

1. rake artifact:osx
2. cp -R build/Release/Objection.framework ${DEST_DIR}
3. In XCode -> Project Icon -> Your Target -> Build Phases -> Link Binary With Libraries -> Add (+) -> Add Other

#### Include framework
    #import <Objection/Objection.h>

### Installation Notes

* There is a glitch in XCode that will cause header files to not be copied properly. So, if you are building the iOS target you may have to run the build process a couple of times to get all of the proper header files copied.

Requirements
============

* MacOS X 10.6 +
* iOS 4.0 +

Authors
=======

* Justin DeWind (dewind@atomicobject.com, @dewind on Twitter)
* © 2009-2012 [Atomic Object](http://www.atomicobject.com/)
* More Atomic Object [open source](http://www.atomicobject.com/pages/Software+Commons) projects
