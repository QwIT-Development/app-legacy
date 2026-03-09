import UIKit
import background_fetch
import ActivityKit
import Flutter
import Security

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var tokenRotationObserver: NSObjectProtocol?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        methodChannel = FlutterMethodChannel(
            name: "app.firka/liveactivity",
            binaryMessenger: controller as! FlutterBinaryMessenger
        )
        methodChannel?.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "createLiveActivity"
                || call.method == "endLiveActivity"
                || call.method == "updateLiveActivity"
            else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.handleMethodCall(call, result: result)
        })

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("LiveActivityDismissed"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            let deviceId = self?.getOrCreateDeviceId() ?? ""
            self?.methodChannel?.invokeMethod("liveActivityDismissed", arguments: [
                "deviceId": deviceId,
            ])
        }

        tokenRotationObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("LiveActivityTokenUpdated"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let newToken = notification.object as? String {
                let deviceId = self?.getOrCreateDeviceId() ?? ""
                let bundleId = Bundle.main.bundleIdentifier ?? ""
                self?.methodChannel?.invokeMethod("liveActivityTokenUpdated", arguments: [
                    "pushToken": newToken,
                    "deviceId": deviceId,
                    "bundleId": bundleId,
                ])
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        if #available(iOS 16.2, *) {
            LiveActivityManager.stop()
        }
        if let observer = tokenRotationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "createLiveActivity" {
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid iOS arguments received", details: nil))
                return
            }
            lessonDataDictionary = args
            globalLessonData = LessonData(from: lessonDataDictionary)
            print("swift: megkapott flutter adatok:", lessonDataDictionary)
            print("Live Activity bekapcsolva az eszközön:", checkLiveActivityFeatureAvailable())

            guard checkLiveActivityFeatureAvailable() else {
                result(nil)
                return
            }

            if #available(iOS 16.2, *) {
                LiveActivityManager.create { success in
                    let deviceId = self.getOrCreateDeviceId()
                    let bundleId = Bundle.main.bundleIdentifier ?? ""
                    result([
                        "success": success,
                        "deviceId": deviceId,
                        "bundleId": bundleId,
                    ])
                }
            } else {
                result(nil)
            }

        } else if call.method == "updateLiveActivity" {
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid iOS arguments received", details: nil))
                return
            }
            lessonDataDictionary = args
            globalLessonData = LessonData(from: lessonDataDictionary)
            if #available(iOS 16.2, *) {
                LiveActivityManager.update()
            }
            result(nil)

        } else if call.method == "endLiveActivity" {
            if #available(iOS 16.2, *) {
                LiveActivityManager.stop()
            }
            result(nil)
        }
    }

    private func getOrCreateDeviceId() -> String {
        let keychainKey = "refilc.live.device_id"
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String:  true,
            kSecMatchLimit as String:  kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
           let data = item as? Data,
           let existingId = String(data: data, encoding: .utf8) {
            return existingId
        }
        let newId = UUID().uuidString
        let addQuery: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String:   newId.data(using: .utf8)!,
        ]
        SecItemAdd(addQuery as CFDictionary, nil)
        return newId
    }

    private func checkLiveActivityFeatureAvailable() -> Bool {
        if #available(iOS 16.2, *) {
            return ActivityAuthorizationInfo().areActivitiesEnabled
        }
        return false
    }
}
