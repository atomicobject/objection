#import "JSObjectionInjector.h"

@interface JSTestObjectionInjector : JSObjectionInjector

- (void)registerMock:(id)mockObject forClassOrProtocol:(id)classOrProtocol;
@end
