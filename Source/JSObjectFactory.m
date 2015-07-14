#import "JSObjectFactory.h"
#import "Objection.h"

@implementation JSObjectFactory

- (instancetype)initWithInjector:(JSObjectionInjector *)injector {
    if ((self = [super init])) {
        _injector = injector;
    }
    return self;
}

- (id)getObject:(id)classOrProtocol {
    return [self.injector getObject:classOrProtocol];
}

- (id)getObject:(id)classOrProtocol withArgumentList:(NSArray *)arguments {
    return [self.injector getObject:classOrProtocol argumentList:arguments];
}

- (id)getObject:(id)classOrProtocol initializer:(SEL)initializer withArgumentList:(NSArray *)arguments {
    return [self.injector getObject:classOrProtocol named:nil initializer:initializer argumentList:arguments];
}

- (id)getObject:(id)classOrProtocol named:(NSString *)named withArgumentList:(NSArray *)arguments {
    return [self.injector getObject:classOrProtocol named:named argumentList:arguments];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self getObject:key];
}

- (id)getObjectWithArgs:(id)classOrProtocol, ... {
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    id object = [self.injector getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

@end
