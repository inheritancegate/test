import AsyncDisplayKit

private var ASDISPLAYNODE_STATE_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension ASDisplayNode {

    public var state: ASDisplayNode.State {
        if let holder = objc_getAssociatedObject(self, &ASDISPLAYNODE_STATE_ASSOCIATED_OBJECT_KEY) as? ASDisplayNode.State {
            return holder
        } else {
            let holder = ASDisplayNode.State()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &ASDISPLAYNODE_STATE_ASSOCIATED_OBJECT_KEY, holder, policy)
            return holder
        }
    }
}

public extension ASDisplayNode {
    
    public final class State {
        
        lazy var alpha: CGFloat = 1.0
        lazy var rect: CGRect = .zero
    }
}

extension ASDisplayNode: FutureProvider {}

// MARK: -

private var ASDISPLAYNODE_CORNER_RADIUS_HOLDER: UInt8 = 0

private final class Holder: NSObject {
    
    var bounds: CGRect = .zero
    var radius: CGFloat = 0
}

public extension ASDisplayNode {
    
    private var holder: Holder {
        get {
            switch objc_getAssociatedObject(self, &ASDISPLAYNODE_CORNER_RADIUS_HOLDER) as? Holder {
            case .some(let value):
                return value
            default:
                let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                let value = Holder()
                objc_setAssociatedObject(self, &ASDISPLAYNODE_CORNER_RADIUS_HOLDER, value, policy)
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
