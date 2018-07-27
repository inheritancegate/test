import AsyncDisplayKit
import Common
import UIKit

enum LaunchArguments: String {
    
    case debugColors
    
    var isEnabled: Bool {
        return ProcessInfo.processInfo.arguments.contains(rawValue)
    }
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = AppDelegate.getWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        ASControlNode.enableHitTestDebug = true
//        ASImageNode.shouldShowImageScalingOverlay = true
        let navigation = UINavigationController(rootViewController: Controller())
        navigation.isNavigationBarHidden = true
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {
    
    static func getWindow() -> UIWindow? {
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        return window
    }
}
