import UIKit

public extension UIResponder {
    
    public func firstViewController() -> UIViewController? {
        var first: UIViewController? = nil
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let current = next as? UIViewController {
                first = current
            }
        }
        return first
    }
}
