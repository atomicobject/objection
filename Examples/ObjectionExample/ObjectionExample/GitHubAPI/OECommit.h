#import <Foundation/Foundation.h>


@interface OECommit : NSObject {
  NSString *_authorName;
  NSDate *_authoredDate;
  NSString *_message;
}

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSDate *authoredDate;
@property (nonatomic, copy) NSString *message;

@end
