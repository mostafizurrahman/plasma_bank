import UIKit
import Flutter

@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if  let controller = window?.rootViewController as? FlutterViewController{
        
        controller.navigationController?
            .interactivePopGestureRecognizer?.isEnabled = false;
        
        let nativeChannel = FlutterMethodChannel.init(
            name: "flutter.plasma.com.device_info",
            binaryMessenger: controller.binaryMessenger)
        nativeChannel.setMethodCallHandler( {
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getPackageInfo" {
                let _bundleID = Bundle.main.bundleIdentifier
                let _type = UIDevice().type.rawValue
                let _imei = UIDevice.current.identifierForVendor?.uuidString
                let _device = _imei ?? "xyz_\(Date.init().timeIntervalSinceNow)"
                result(["package_name" : _bundleID,
                        "device_name" : _type,
                        "device_id":_device ])
            }
        })
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

