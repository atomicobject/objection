#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "Fixtures.h"

@interface ViewController : NSObject
@property (nonatomic, strong) Car *car;
@property (nonatomic, copy) NSString *nibName;
@property (nonatomic, copy) NSBundle *bundle;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (instancetype)initWithName:(NSString *)name;
@end

@interface ConfigurableCar : NSObject
@property (nonatomic, strong) Car *car;
@property (nonatomic, strong) Engine *engine;

@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSNumber *horsePower;
@property (nonatomic, copy) NSNumber *year;

- (id)initWithModel:(NSString *)model horsePower:(NSNumber *)horsePower andYear:(NSNumber *)year;
@end

@interface BadInitializer : NSObject
@end

@interface Truck : NSObject
@property(nonatomic, strong) NSString *name;
+ (id)truck: (NSString *)name;
@end

@interface FilterInitInitializer : NSObject
@end

