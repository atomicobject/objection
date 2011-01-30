Description
===========

A lightweight dependency injection framework for Objective-C. With support for iOS and MacOS X.

Synopsis
========

### Basic Usage

A class can be registered with objection using the macros *objection_register* or *objection_register_singleton*. The *objection_requires* macro can be used to declare what dependencies objection should provide to all instances it creates of that class. *objection_requires* can be used safely with inheritance.

#### Example

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


### Fetching Objects from Objection

An object can be fetched from objection by creating an injector and then asking for an instance of a particular class or protocol. An injector manages its own object context. Which means that a singleton is per injector and is not necessarily a *true* singleton.

    - (void)someMethod {
      ObjectionInjector *injector = [Objection createInjector];
      id car = [injector getObject:[Car class]];
    }

A global injector can be registered with Objection which can be used throughout your application or library.
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
      ObjectionInjector *injector = [Objection createInjector];
      [Objection setGlobalInjector:injector];
    }
    
    - (void)viewDidLoad {
      id myModel = [[Objection globalInjector] getObject:[MyModel class]];
    }

### Registering Instances

Objection supports associating an object outside the context of Objection by configuring an ObjectionModule.

### Example
      @interface MyAppModule : ObjectionModule {
        
      }
      @end
      
      @implementation MyAppModule
      - (void)configure {
        [self bind:[UIApplication sharedApplication] toClass:[UIApplication class]];
        [self bind:[UIApplication sharedApplication].delegate toProtocol:@protocol(UIApplicationDelegate)];
      }
      
      @end
      - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
        ObjectionInjector *injector = [Objection createInjector:[[[MyAppModule alloc] init] autorelease]];
        [Objection setGlobalInjector:injector];
      }

### Instance Creation Notification

If an object is interested in knowing when it has been fully instantiated by objection it can implement the method
*awakeFromObjection*.

#### Example
      @implementation Car
      //...
      objection_register_singleton(Car)
        - (void)awakeFromObjection {
          awake = YES;
        }
      @end  
      

### TODO

* Diagram class initialization and its relationship with Objection
* Support eager singletons

Installation
=======

### iOS

1. git clone git://github.com/atomicobject/objection.git
2. Open Objection.xcodeproj
3. Select Objection-iPhone target
4. Select Release Configuration
5. Build
6. Add -ObjC and -all_load to Other Link Flags in your project

#### Include framework
    #import <Objection-iPhone/Objection.h>

### MacOS X

1. git clone git://github.com/atomicobject/objection.git
2. Open Objection.xcodeproj
3. Select Objection target
4. Select Release Configuration.
5. Build

#### Include framework
    #import <Objection/Objection.h>

Requirements
============

* MacOS X 10.6 +
* iOS 3.0 +

Authors
=======

* Justin DeWind (dewind@atomicobject.com)
* © 2009-2011 [Atomic Object](http://www.atomicobject.com/)
* More Atomic Object [open source](http://www.atomicobject.com/pages/Software+Commons) projects
