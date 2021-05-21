#import "SpecterRustPlugin.h"
#if __has_include(<specter_rust/specter_rust-Swift.h>)
#import <specter_rust/specter_rust-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "specter_rust-Swift.h"
#endif

@implementation SpecterRustPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpecterRustPlugin registerWithRegistrar:registrar];
}
@end
