
Class ObjectionFindClassForProperty(objc_property_t property);

objc_property_t ObjectionGetProperty(Class klass, NSString *propertyName);

NSSet* ObjectionBuildDependenciesForClass(Class klass, NSSet *requirements);