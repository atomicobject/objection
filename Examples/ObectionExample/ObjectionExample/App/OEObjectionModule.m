#import "OEObjectionModule.h"
#import "ASINetworkQueue.h"


@implementation OEObjectionModule
- (void)configure {
  [self bind:[ASINetworkQueue queue] toClass:[ASINetworkQueue class]];
}
@end
