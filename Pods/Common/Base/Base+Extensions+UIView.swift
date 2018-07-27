import UIKit

public extension UIView {

    public static func animate(animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil, delay: TimeInterval = 0, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}

public extension UIView {

    public func hideKeyboard() {
        if self.isFirstResponder {
            resignFirstResponder()
        }
        for view in subviews {
            view.hideKeyboard()
        }
    }
}

public extension UIView {

    public var firstResponder: UIView? {
        switch isFirstResponder {
        case true:
            return self
        default:
            for subview in subviews {
                if let firstResponder = subview.firstResponder {
                    return firstResponder
                }
            }
        }
        return nil
    }
}

public extension UIView {

    public static func instantiateFromNib() -> Self {
        func instanceFromNib<T: UIView>() -> T {
            switch UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? T {
            case .some(let view):
                return view
            case .none:
                fatalError()
            }
        }
        return instanceFromNib()
    }
}

// MARK: -

private var UIVIEW_CORNER_RADIUS_HOLDER: UInt8 = 0

private final class Holder: NSObject {

    var bounds: CGRect = .zero
    var radius: CGFloat = 0
}

public extension UIView {

    private var holder: Holder {
        get {
            switch objc_getAssociatedObject(self, &UIVIEW_CORNER_RADIUS_HOLDER) as? Holder {
            case .some(let value):
                return value
            default:
                let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                let value = Holder()
                objc_setAssociatedObject(self, &UIVIEW_CORNER_RADIUS_HOLDER, value, policy)
                return value
            }
        }
    }

    private var mask: CAShapeLayer? {
        get {
            return layer.mask as? CAShapeLayer
        }
        set {
            layer.mask = newValue
        }
    }
    /// Скруглить края. Должно вызываться в layoutSubview или подобном методе, т.к. bounds уже должен быть обновлен
    public func updateCorner(radius: CGFloat) {
                
        func update(bounds: CGRect, holder: Holder, mask: CAShapeLayer, radius: CGFloat) {
            holder.bounds = bounds
            holder.radius = radius
            mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        }
        
        let holder = self.holder
        switch (mask, radius > 0) {
        case (.none, false):
            holder.bounds = bounds
            holder.radius = 0
        case (.none, true):
            let mask = CAShapeLayer()
            self.mask = mask
            update(bounds: bounds, holder: holder, mask: mask, radius: radius)
        case (.some, false):
            mask = nil
            holder.bounds = bounds
            holder.radius = 0
        case (.some(let mask), true):
            switch bounds == holder.bounds && radius == holder.radius {
            case true:
                break
            case false:
                update(bounds: bounds, holder: holder, mask: mask, radius: radius)
            }
        }
    }
}
