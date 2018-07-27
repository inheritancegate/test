import AsyncDisplayKit

public protocol TXNodeAnimationProvider: class {
    
    func applyCustomAnimation(animated: Bool, curve: UIViewAnimationCurve, duration: TimeInterval, initial: TXNodeTransitioningValue, final: TXNodeTransitioningValue) -> Bool
}
