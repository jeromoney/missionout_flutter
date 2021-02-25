import UIKit
import Flutter
import GoogleMaps
import UserNotifications
import Pushy
import Firebase


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
            guard call.method == "requestCriticalAlertEntitlement" || call.method == "getCriticalAlertStatus" else {
                result(FlutterMethodNotImplemented)
                return
              }
            if (call.method == "requestCriticalAlertEntitlement")
            {  self.registerForPushNotifications(result: result)}
            else if (call.method == "getCriticalAlertStatus")
            {
                self.isCriticalAlertEnabled(result: result)
            }
            return
        })
       
        GMSServices.provideAPIKey("AIzaSyCP_6jcpufFZh45nm85ZGt1meLhPEeSn-M")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func registerForPushNotifications(result: @escaping FlutterResult){
        print("Requesting permisison for critical alerts entitlement")
        if #available(iOS 12.0, *)
        {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.criticalAlert]){ granted, _ in
                    print("Permission granted: \(granted)")
                    result("granted")
                }
        }
    }
    
    private func isCriticalAlertEnabled(result: @escaping FlutterResult){
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings {(settings) in
                print(settings.criticalAlertSetting.rawValue)
                result(settings.criticalAlertSetting.rawValue)
            }
        } else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Critical Alert information is unavailable",
                                details: nil))
        }
    }
    
    // APNs has assigned the device a unique token
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Call internal Pushy SDK method
        Pushy.shared?.application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)

        // Pass token to Firebase SDK
        Messaging.messaging().apnsToken = deviceToken
    }

    // APNs failed to register the device for push notifications
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Call internal Pushy SDK method
        Pushy.shared?.application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    }

    // Device received notification (legacy callback)
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Call internal Pushy SDK method
        Pushy.shared?.application(application, didReceiveRemoteNotification:userInfo)

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }

    // Device received notification (with completion handler)
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Call internal Pushy SDK method
        Pushy.shared?.application(application, didReceiveRemoteNotification:userInfo, fetchCompletionHandler: completionHandler)

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
}


