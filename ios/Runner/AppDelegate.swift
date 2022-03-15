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
             WonderPush.setClientId("f778069d44cd24e28ab85336fd87eaee7f354e4b", secret: "522bd44494ed999b994ad798be36fced8bcb8f0868d5ffa4bc45108fc96fe0ff")
             WonderPush.setupDelegate(for: application)
             if #available(iOS 10.0, *) {
                 WonderPush.setupDelegateForUserNotificationCenter()
             }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
