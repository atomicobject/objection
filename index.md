---
title: objection - iOS/MacOS X Dependency Injection Framework
layout: default
---

[GitHub](https://github.com/atomicobject/objection/) |
[Issues](https://github.com/atomicobject/objection/issues) |
[Installation](#installation) |
[Atomic Object](http://www.atomicobject.com)

# ![objection](dependency_injection.png) 

## Overview

objection is a lightweight [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) framework for Objective-C for MacOS X and iOS. For those of you that have used [Guice](http://code.google.com/p/google-guice/) objection will feel familiar. Objection was built to stay out of your way and alleviate the need to maintain a large XML container or manually construct objects.

## Features

* "Annotation" Based Dependency Injection
* Does not require that a large upfront container is maintained
* Lazy Instantiation over Eager Instantiation
* Alleviates the need to manually construct objects or rely on factories
* Support for integrating external dependencies

<script src="https://gist.github.com/806214.js"> </script>

## Usage

For a technical overview of framework please visit the [GitHub page](https://github.com/atomicobject/objection/)

## Installation

### iOS

1. git clone git://github.com/atomicobject/objection.git
2. Open Objection.xcodeproj
3. Select Objection-iOS target
4. Select Release Configuration
5. Build
6. Add -ObjC and -all_load to Other Link Flags in your project

#### Include framework
    #import <Objection-iOS/Objection.h>

### MacOS X

1. git clone git://github.com/atomicobject/objection.git
2. Open Objection.xcodeproj
3. Select Objection target
4. Select Release Configuration.
5. Build

#### Include framework
    #import <Objection/Objection.h>