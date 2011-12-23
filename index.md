---
title: Objection - iOS/MacOS X Dependency Injection Framework
layout: default
---

[GitHub](https://github.com/atomicobject/objection/) |
[Issues](https://github.com/atomicobject/objection/issues) |
[Installation](#installation) |
[Usage](#usage) |
[Atomic Object](http://www.atomicobject.com)

# ![objection](dependency_injection.png) 

## Overview

objection is a lightweight [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) framework for Objective-C for MacOS X and iOS. For those of you that have used [Guice](http://code.google.com/p/google-guice/) objection will feel familiar. Objection was built to stay out of your way and alleviate the need to maintain a large XML container or manually construct objects.

## Features

* "Annotation" Based Dependency Injection
* Seamless support for integrating custom and external dependencies
  * Custom Object Providers
  * Meta Class Bindings
  * Protocol Bindings
  * Instance Bindings
* Lazily instantiates dependencies
* Eager Singletons

<script src="https://gist.github.com/806214.js"> </script>

## Usage

For a technical overview of the framework please visit the [GitHub page](https://github.com/atomicobject/objection/)

## Installation
    git clone git://github.com/atomicobject/objection.git
    git checkout 0.10.1
     
### iOS

1. rake artifact:ios
2. cp -R build/Release-iphoneuniversal/Objection-iOS.framework ${DEST_DIR}
3. Add -ObjC and -all_load to Other Link Flags in your project

#### Include framework
    #import <Objection-iOS/Objection.h>

### MacOS X

1. rake artifact:osx
2. cp -R build/Release/Objection.framework ${DEST_DIR}

#### Include framework
    #import <Objection/Objection.h>

### Installation Notes

* There is a glitch in XCode that will cause header files to not be copied properly. So, if you are building the iOS target you may have to run the build process a couple of times to get all of the proper header files copied.
