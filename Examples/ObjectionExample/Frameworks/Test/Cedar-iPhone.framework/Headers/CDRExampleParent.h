#import <Foundation/Foundation.h>

@protocol CDRExampleParent

- (void)setUp;
- (void)tearDown;

@optional
- (BOOL)hasFullText;
- (NSString *)fullText;

@end
