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

@property(nonatomic, retain) NSObject *someObject;

@end

@interface ReadOnlyPropertyObject : NSObject
{
  NSObject *_someObject;
}

@property(nonatomic, readonly) NSObject *someObject;

@end

