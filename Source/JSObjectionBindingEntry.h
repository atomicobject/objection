#import <Foundation/Foundation.h>
#import "JSObjectionEntry.h"

@interface JSObjectionBindingEntry : JSObjectionEntry {
    id _instance;
}

- (id)initWithObject:(id)theObject;
@end
