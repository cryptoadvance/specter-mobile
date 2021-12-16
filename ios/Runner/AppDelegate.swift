import UIKit
import Flutter
import CryptoKit
import SecureCommunications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "specter.mobile/service", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
    (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      if (call.method == "HmacSHA256Sign") {
          let args = call.arguments as? Dictionary<String, Any>;
          let keyName = args!["keyName"] as? String;
          let toSign = args!["toSign"] as? String;
          
          let message = toSign!;
          
          //
          var publicKey: P256.KeyAgreement.PublicKey;
          do {
              publicKey = try KeyStore().publicKey();
          } catch {
              result("error");
              return;
          }
          
          let sign = message.authenticationCodeHMAC(
              recipientPublicKey: publicKey,
              salt: toSign!
          )
          
          //
          result("{\"sign\": \"" + sign! + "\"}");
          return;
      }
      
      result(FlutterMethodNotImplemented);
    });
  
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func getSymmetricKey(privateKey: SecureEnclave.P256.KeyAgreement.PrivateKey, salt: String) throws -> SymmetricKey {
        return try privateKey
            .sharedSecretFromKeyAgreement(with: try KeyStore().publicKey())
            .hkdfDerivedSymmetricKey(
                using: SHA512.self,
                salt: salt.data(using: .utf8)!,
                sharedInfo: Data(),
                outputByteCount: 32)
    }
}
