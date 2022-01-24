import UIKit
import Flutter
// Add this line
import WonderPush
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
                 UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
             }
             
             GeneratedPluginRegistrant.register(with: self)
             
             // Add the following 5 lines
             WonderPush.setClientId("YOUR_CLIENT_ID", secret: "YOUR_CLIENT_SECRET")
             WonderPush.setupDelegate(for: application)
             if #available(iOS 10.0, *) {
                 WonderPush.setupDelegateForUserNotificationCenter()
             }
             
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
