import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.destinyed.veto/blocker",
                                        binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "lockApps":
        // Family Controls / ManagedSettings requires the Family Controls entitlement.
        // Apple rarely grants this to non-parental-control apps.
        // Structure is here; will fail gracefully without the entitlement.
        if let args = call.arguments as? [String: Any],
           let packages = args["packages"] as? [String] {
          self?.applyShield(packages: packages, lock: true)
        }
        result(true)
      case "unlockApps":
        self?.applyShield(packages: [], lock: false)
        result(true)
      case "requestPermissions":
        // Opens Screen Time settings as fallback guidance
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
        result(true)
      case "isAccessibilityEnabled":
        result(false) // Not applicable on iOS
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func applyShield(packages: [String], lock: Bool) {
    // Placeholder for ManagedSettingsStore
    // import ManagedSettings
    // let store = ManagedSettingsStore()
    // if lock {
    //   store.shield.applications = Set(packages.map { Application(bundleIdentifier: $0) })
    // } else {
    //   store.shield.applications = nil
    // }
    print("iOS shield request: lock=\(lock) packages=\(packages)")
    print("Note: Requires Family Controls entitlement to actually block apps.")
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
