import UIKit

public extension UINavigationController {
    
    @discardableResult
    func pop(animated: Bool, completion: (() -> ())? = nil) -> UIViewController? {
        defer {
            switch animated {
            case true:
                switch transitionCoordinator {
                case .some(let transitionCoordinator):
                    let animating = transitionCoordinator.animate(alongsideTransition: nil) { _ in
                        completion?()
                    }
                    switch animating {
                    case true:
                        break
                    case false:
                        completion?()
                    }
                default:
                    completion?()
                }
            case false:
                completion?()
            }
        }
        return popViewController(animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        defer {
            switch animated {
            case true:
                switch transitionCoordinator {
                case .some(let transitionCoordinator):
                    let animating = transitionCoordinator.animate(alongsideTransition: nil) { _ in
                        completion?()
                    }
                    switch animating {
                    case true:
                        break
                    case false:
                        completion?()
                    }
                default:
                    completion?()
                }
            case false:
                completion?()
            }
        }
        pushViewController(viewController, animated: animated)
    }
    
    func replace(_ viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        guard viewController != viewControllers.last else {
            completion?()
            return
        }
        if viewControllers.count > 1 {
            setViewControllers([viewControllers.last].flatMap({ $0 }), animated: false)
        }
        push(viewController, animated: animated) { [weak self] in
            self?.setViewControllers([self?.viewControllers.last].flatMap({ $0 }), animated: false)
            completion?()
        }
    }
}
