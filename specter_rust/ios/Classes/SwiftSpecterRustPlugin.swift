import Flutter
import UIKit

public class SwiftSpecterRustPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "specter_rust", binaryMessenger: registrar.messenger())
    let instance = SwiftSpecterRustPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func intertMethodToEnforceBundling() {
    // This will never be executed
    mnemonic_from_entropy("")
    mnemonic_to_root_key("", "")
    derive_xpub("", "", "")
    get_descriptors("", "", "", "")
    derive_addresses("", "", 0, 0)
    rust_greeting("")
    rust_cstr_free(nil)
    run_bitcoin_demo()
  }
}
