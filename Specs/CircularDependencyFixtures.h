@class SingletonFoo;

@protocol BarProtocol
@end

@interface SingletonBar : NSObject <BarProtocol>
{
    SingletonFoo *foo;
}

@property(nonatomic, strong) SingletonFoo *foo;

@end