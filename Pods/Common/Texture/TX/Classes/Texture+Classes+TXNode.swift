import AsyncDisplayKit

open class TXNode: ASDisplayNode {
    
    public weak var delegate: TXNodeTransitioningDelegate?
    
    internal override init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = UIColor.white
    }
    
    var controller: TXViewController {
        return closestViewController as! TXViewController
    }

    internal var transitionLayoutAllowed: Bool {
        get {
            return transitionLayoutAllowedMutex.sync(block: { transitionLayoutAllowedBacker })
        }
        set {
            transitionLayoutAllowedMutex.sync(block: { transitionLayoutAllowedBacker = newValue })
        }
    }
    private var transitionLayoutAllowedBacker: Bool = false
    private var transitionLayoutAllowedMutex = Mutex()
    
    open override func transitionLayout(withAnimation animated: Bool, shouldMeasureAsync: Bool, measurementCompletion completion: (() -> Void)? = nil) {
        assert(transitionLayoutAllowed, "You are not allowed to manually call \"transitionLayout(withAnimation:shouldMeasureAsync:measurementCompletion:)\"")
        transitionLayoutAllowed = false
        super.transitionLayout(withAnimation: animated, shouldMeasureAsync: shouldMeasureAsync, measurementCompletion: completion)
    }
    
    override open func animateLayoutTransition(_ context: ASContextTransitioning) {
        let animated = context.isAnimated()
        let completion: (Bool) -> Void = { [weak context] (didComplete: Bool) -> Void in
            context?.completeTransition(didComplete)
        }
        let curve = controller.curve
        let duration = controller.duration
        let key = controller.key
        let objects = context
            .animatedSubnodes()
            .compactMap({ [weak context] (node: ASDisplayNode) -> TXNodeTransitioningObject? in
                return context?.getTransitioningObject(node)
            })
        switch delegate {
        case .some(let delegate):
            delegate.transition(animated: animated, completion: completion, curve: curve, duration: duration, key: key, objects: objects)
        default:
            _transition(animated: animated, completion: completion, curve: curve, duration: duration, key: key, objects: objects)
        }
    }
    
    private func _transition(animated: Bool, completion: @escaping (Bool) -> Void, curve: UIViewAnimationCurve, duration: TimeInterval, key: String, objects: [TXNodeTransitioningObject]) {
        let animations = objects
            .filterWithoutAnimationApplied(animated: animated, curve: curve, duration: duration)
            .animations()
        switch animated {
        case false:
            animations()
            completion(true)
        default:
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        }
    }
}
