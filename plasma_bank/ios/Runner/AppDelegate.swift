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
        
        let nativeChannel = FlutterMethodChannel.init(name: "flutter.plasma.com.imgpath",
        binaryMessenger: controller.binaryMessenger);
        nativeChannel.setMethodCallHandler( {
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getImagePath" {
                if let _imagePath = Bundle.main.path(forResource: "mkt", ofType: "jpg") {
                    result(["image_path" : _imagePath])
                } else {
                    result(["image_path" : "-"])
                }
            }
        })
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
