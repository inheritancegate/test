import UIKit

public extension UIViewController {
    
    public func hideKeyboard() {
        view.hideKeyboard()
    }
}

public extension UIViewController {
    
    public func show(_ viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        guard viewController != presentedViewController else {
            completion?()
            return
        }
        switch animated {
        case true:
            if let presentedViewController = presentedViewController {
                presentedViewController.dismiss(animated: true, completion: { [weak self] in
                    self?.present(viewController, animated: true, completion: {
                        completion?()
                    })
                })
            } else {
                present(viewController, animated: true, completion: {
                    completion?()
                })
            }
        case false:
            presentedViewController?.dismiss(animated: false)
            present(viewController, animated: false, completion: {
                completion?()
            })
        }
    }
}

private var SHOULD_HIDE_BOTTOM_BAR_WHEN_PUSHED_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension UIViewController {
    
    public var shouldHideBottomBarWhenPushed: Bool {
        get {
            if let shouldHide = objc_getAssociatedObject(self, &SHOULD_HIDE_BOTTOM_BAR_WHEN_PUSHED_ASSOCIATED_OBJECT_KEY) as? NSNumber {
                return shouldHide.boolValue
            } else {
                let shouldHide = NSNumber(value: hidesBottomBarWhenPushed)
                let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                objc_setAssociatedObject(self, &SHOULD_HIDE_BOTTOM_BAR_WHEN_PUSHED_ASSOCIATED_OBJECT_KEY, shouldHide, policy)
                return shouldHide.boolValue
            }
        }
        set {
            hidesBottomBarWhenPushed = newValue
            let shouldHide = NSNumber(value: newValue)
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &SHOULD_HIDE_BOTTOM_BAR_WHEN_PUSHED_ASSOCIATED_OBJECT_KEY, shouldHide, policy)
        }
    }
}
