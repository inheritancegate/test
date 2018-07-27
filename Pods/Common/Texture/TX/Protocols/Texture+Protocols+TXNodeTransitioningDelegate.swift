import AsyncDisplayKit

public protocol TXNodeTransitioningDelegate: class {
    
    func transition(animated: Bool, completion: @escaping (Bool) -> Void, curve: UIViewAnimationCurve, duration: TimeInterval, key: String, objects: [TXNodeTransitioningObject])
}
