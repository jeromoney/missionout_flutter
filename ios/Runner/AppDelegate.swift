import UIKit
import Flutter
import GoogleMaps
import UserNotifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Adding Critical Alerts platform channel
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let criticalAlertChannel = FlutterMethodChannel(name: "missionout.beaterboofs.com/criticalAlertsEntitlement",
                                                    binaryMessenger: controller.binaryMessenger)
    criticalAlertChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        self.registerForPushNotifications()
        return
        })
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GMSServices.provideAPIKey("AIzaSyCP_6jcpufFZh45nm85ZGt1meLhPEeSn-M")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   private func registerForPushNotifications(){
        print("Requesting permisison for critical alerts entitlement")
        if #available(iOS 12.0, *)
        {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.criticalAlert]){ granted, _ in
                print("Permission granted: \(granted)")
              }}
    }
}


