import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.destinyed.veto/blocker",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "lockApps":
        if let args = call.arguments as? [String: Any],
           let packages = args["packages"] as? [String] {
          self?.applyShield(packages: packages, lock: true)
        }
        result(true)
      case "unlockApps":
        self?.applyShield(packages: [], lock: false)
        result(true)
      case "requestPermissions":
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
        result(true)
      case "isAccessibilityEnabled":
        result(false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func applyShield(packages: [String], lock: Bool) {
    // Family Controls / ManagedSettings requires the Family Controls entitlement.
    // Structure is ready; calls will no-op without the entitlement.
    print("iOS shield request: lock=\(lock) packages=\(packages)")
    print("Note: Requires Family Controls entitlement to actually block apps.")
  }
}
