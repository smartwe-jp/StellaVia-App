import Flutter
import Foundation
import GoogleMaps
import UIKit
import UserNotifications
import CloudPushSDK

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    configureGoogleMaps()
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

  private func configureGoogleMaps() {
    guard let apiKey = Self.dartDefineValue(
      for: ["GOOGLE_MAPS_IOS_API_KEY", "GOOGLE_MAPS_API_KEY"]
    ) else {
      return
    }
    GMSServices.provideAPIKey(apiKey)
  }

  private static func dartDefineValue(for keys: [String]) -> String? {
    let values = dartDefineValues()
    for key in keys {
      guard let value = values[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
            !value.isEmpty else {
        continue
      }
      return value
    }
    return nil
  }

  private static func dartDefineValues() -> [String: String] {
    guard let encodedDefines = Bundle.main.object(forInfoDictionaryKey: "DART_DEFINES") as? String else {
      return [:]
    }

    var values: [String: String] = [:]
    for encodedDefine in encodedDefines.split(separator: ",") {
      guard let data = Data(base64Encoded: String(encodedDefine), options: .ignoreUnknownCharacters),
            let decoded = String(data: data, encoding: .utf8),
            let separatorIndex = decoded.firstIndex(of: "=") else {
        continue
      }

      let key = String(decoded[..<separatorIndex])
      let valueStartIndex = decoded.index(after: separatorIndex)
      values[key] = String(decoded[valueStartIndex...])
    }
    return values
  }
}
