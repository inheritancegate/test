import AsyncDisplayKit
import UIKit
import UIPanGestureRecognizerDirection

class ASNavigationInteractiveController: ASNavigationController {
    
    public weak var interactivePopDelegate: ASNavigationInteractiveControllerDelegate?
    fileprivate lazy var gestureRecognizerDelegate = GestureRecognizerDelegate()
    fileprivate lazy var navigationControllerDelegate = NavigationControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        setToolbarHidden(true, animated: false)
        delegate = navigationControllerDelegate
        gestureRecognizerDelegate.navigationControllerFactory = { [weak self] in self }
        interactivePopGestureRecognizer?.delegate = gestureRecognizerDelegate
        navigationControllerDelegate.navigationControllerFactory = { [weak self] in self }
        if let gestureRecognizer = interactivePopGestureRecognizer as? UIPanGestureRecognizer {
            if gestureRecognizer.direction != .horizontal {
                gestureRecognizer.direction = .horizontal
            }
        }
    }
}

protocol ASNavigationInteractiveControllerDelegate: class {
    
    func navigationInteractiveController(_ controller: ASNavigationInteractiveController, didPopInteractively: Void)
}

// MARK: - UIGestureRecognizerDelegate

private final class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    lazy var navigationControllerFactory: () -> ASNavigationInteractiveController? = { nil }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if gestureRecognizer.direction != .horizontal {
                gestureRecognizer.direction = .horizontal
            }
        }
        guard let navigationController = navigationControllerFactory() else {
            return false
        }
        return navigationController.viewControllers.count > 1
    }
}

// MARK: - UINavigationControllerDelegate

private final class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    lazy var navigationControllerFactory: () -> ASNavigationInteractiveController? = { nil }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            coordinator.notifyWhenInteractionEnds({ [navigationControllerFactory] (context) in
                if let navigationController = navigationControllerFactory() {
                    navigationController.interactivePopDelegate?.navigationInteractiveController(navigationController, didPopInteractively: ())
                }
            })
        }
    }
}
