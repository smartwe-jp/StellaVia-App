import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    clearApplicationBadge(application)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    clearApplicationBadge(application)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func clearApplicationBadge(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }
  }
}
