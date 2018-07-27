import AsyncDisplayKit

public extension Array where Element == TXNodeTransitioningObject {
    
    public func animations() -> () -> () {
        return { [objects = self] in
            for object in objects {
                let alpha: CGFloat = object.final.hidden ? 0 : 1
                let frame = object.final.frame
                let node = object.node
                if node?.future.alpha != alpha {
                    node?.alpha = alpha
                    node?.future.alpha = alpha
                }
                if node?.future.frame != frame {
                    node?.frame = frame
                    node?.future.frame = frame
                }
            }
        }
    }
    
    public func filterWithoutAnimationApplied(animated: Bool, curve: UIViewAnimationCurve, duration: TimeInterval) -> [TXNodeTransitioningObject] {
        return filter({ (object) -> Bool in
            switch object.node as? TXNodeAnimationProvider {
            case .some(let provider):
                let applied = provider.applyCustomAnimation(animated: animated, curve: curve, duration: duration, initial: object.initial, final: object.final)
                return applied == false
            default:
                return true
            }
        })
    }
}
