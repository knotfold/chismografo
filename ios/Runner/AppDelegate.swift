import UIKit
import Flutter
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    @available(iOS 9.0, *)
    override  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return ApplicationDelegate.shared.application(application,  open: url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

 
}
