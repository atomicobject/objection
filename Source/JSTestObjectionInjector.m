#import "JSTestObjectionInjector.h"

@interface JSTestObjectionInjector ()

@property (strong, nonatomic) NSMutableDictionary *mocks;

@end

@implementation JSTestObjectionInjector

- (id)getObject:(id)classOrProtocol argumentList:(NSArray *)argumentList {
    @synchronized(self) {
        if (!classOrProtocol) {
            return nil;
        }
        
        NSString *key = [self getKeyForClassOrProtocol:classOrProtocol];
        
        id object = [self.mocks objectForKey:key];
        
        if (!object) {
            object = [super getObject:classOrProtocol argumentList:argumentList];
        }
        
        return object;
    }
}

#pragma mark - Public

- (void)registerMock:(id)mockObject forClassOrProtocol:(id)classOrProtocol {
    NSParameterAssert(mockObject);
    NSParameterAssert(classOrProtocol);
    
    NSString *key = [self getKeyForClassOrProtocol:classOrProtocol];
    [self.mocks setObject:mockObject forKey:key];
}

#pragma mark - Private

- (NSString *)getKeyForClassOrProtocol:(id)classOrProtocol {
    NSString *key = nil;
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    
    if (isClass) {
        key = NSStringFromClass(classOrProtocol);
    } else {
        key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
    }
    
    return key;
}

- (NSMutableDictionary *)mocks {
    if (!_mocks) {
        _mocks = [NSMutableDictionary new];
    }
    
    return _mocks;
}

@end
