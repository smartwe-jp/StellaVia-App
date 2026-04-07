import Flutter
import UIKit
import UserNotifications
import CloudPushSDK

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    installBadgeResetObservers()
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

  private func installBadgeResetObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleBadgeResetLifecycleEvent),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleBadgeResetLifecycleEvent),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    if #available(iOS 13.0, *) {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleBadgeResetLifecycleEvent),
        name: UIScene.didActivateNotification,
        object: nil
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleBadgeResetLifecycleEvent),
        name: UIScene.willEnterForegroundNotification,
        object: nil
      )
    }
  }

  @objc private func handleBadgeResetLifecycleEvent() {
    clearApplicationBadge(UIApplication.shared)
  }

  private func clearApplicationBadge(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }
    CloudPushSDK.syncBadgeNum(0) { _ in }
  }
}
