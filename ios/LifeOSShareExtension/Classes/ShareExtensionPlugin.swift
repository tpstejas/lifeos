//
//  ShareExtensionPlugin.swift
//  Runner
//
//  Created for LifeOS - Your Second Brain with Hybrid AI
//

import Flutter
import Foundation

public class ShareExtensionPlugin: NSObject, FlutterPlugin {
    private let appGroupIdentifier = "group.com.lifeos.app"
    private let sharedKey = "sharedItems"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.lifeos.app/share_extension", binaryMessenger: registrar.messenger())
        let instance = ShareExtensionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPendingSharedItems":
            getPendingSharedItems(result: result)
        case "hasPendingSharedItems":
            hasPendingSharedItems(result: result)
        case "clearPendingSharedItems":
            clearPendingSharedItems(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getPendingSharedItems(result: @escaping FlutterResult) {
        let items = loadSharedItems()
        clearSharedItems()
        result(items)
    }

    private func hasPendingSharedItems(result: @escaping FlutterResult) {
        let items = loadSharedItems()
        result(!items.isEmpty)
    }

    private func clearPendingSharedItems(result: @escaping FlutterResult) {
        clearSharedItems()
        result(nil)
    }

    private func loadSharedItems() -> [[String: Any]] {
        guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier),
              let items = userDefaults.array(forKey: sharedKey) as? [[String: Any]] else {
            return []
        }
        return items
    }

    private func clearSharedItems() {
        guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier) else { return }
        userDefaults.removeObject(forKey: sharedKey)
        userDefaults.synchronize()
    }
}
