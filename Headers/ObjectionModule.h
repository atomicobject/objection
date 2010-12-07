@interface ObjectionModule : NSObject {
  NSMutableDictionary *_moduleContext;
}

- (void) bind:(id)instance toClass:(Class)aClass;
- (void) configure;
@end