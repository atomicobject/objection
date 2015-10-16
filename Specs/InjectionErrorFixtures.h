#import <Foundation/Foundation.h>

@interface UnsupportedPropertyObject : NSObject {
    NSInteger myInteger;  
}

@property(nonatomic, assign) NSInteger myInteger;
@end

@interface BadPropertyObject : NSObject
{
    NSObject *someObject;
}

@property(nonatomic, strong) NSObject *someObject;

@end

@interface ReadOnlyPropertyObject : NSObject

@property(weak, nonatomic, readonly) NSObject *someObject;

@end

@interface NamedUnsupportedPropertyObject : NSObject {
    NSInteger myInteger;
}

@property(nonatomic, assign) NSInteger myInteger;
@end

@interface NamedBadPropertyObject : NSObject
{
    NSObject *someObject;
}

@property(nonatomic, strong) NSObject *someObject;

@end
