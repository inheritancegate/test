import UIKit

public extension UIEdgeInsets {
    
    public init(bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil) {
        self.init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
    }
    
    public static func -(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
    }
    
    public static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
    
    public func with(bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil) -> UIEdgeInsets {
        return UIEdgeInsets(bottom: bottom ?? self.bottom, left: left ?? self.left, right: right ?? self.right, top: top ?? self.top)
    }
}
