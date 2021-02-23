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
}


