import AsyncDisplayKit
import UIKit

public protocol ASViewNodeCompatible: class {}
extension UIView: ASViewNodeCompatible {}

public extension ASViewNodeCompatible where Self: UIView {
    
    public static func node(block: @escaping () -> Self, completion: (() -> ())? = nil) -> ASViewNode<Self> {
        return ASViewNode<Self>(block: block, completion: completion)
    }
}

public class ASViewNode<T>: ASDisplayNode where T: UIView {
    
    public var object: T? {
        get {
            return completed ? (view as? T) : nil
        }
    }
    private lazy var completed: Bool = false
    private var completion: (() -> ())?
    
    public convenience init<T>(block: @escaping () -> T, completion: (() -> ())? = nil) where T: UIView {
        self.init(viewBlock: block)
        self.completion = completion
    }
    
    public override func didLoad() {
        super.didLoad()
        completed = true
        completion?()
    }
}
