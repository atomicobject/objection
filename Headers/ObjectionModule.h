@interface ObjectionModule : NSObject {
  NSMutableDictionary *_bindings;
}

@property (nonatomic, readonly) NSDictionary *bindings;

- (void) bind:(id)instance toClass:(Class)aClass;
- (void) configure;
@end