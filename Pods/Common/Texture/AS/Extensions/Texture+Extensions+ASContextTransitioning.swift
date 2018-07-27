import AsyncDisplayKit

public extension ASContextTransitioning {
    
    public func getTransitioningObject(_ node: ASDisplayNode) -> TXNodeTransitioningObject {
        let initial = TXNodeTransitioningValue(frame: getFrame(node, initial: true), hidden: getHidden(node, initial: true))
        let final = TXNodeTransitioningValue(frame: getFrame(node, initial: false), hidden: getHidden(node, initial: false))
        weak var _node = node
        return (initial, final, _node)
    }

    private func getHidden(_ node: ASDisplayNode, initial: Bool) -> Bool {
        let frame = initial ? initialFrame(for: node) : finalFrame(for: node)
        return (frame.isNull || frame.isInfinite) ? true : false
    }
    
    private func getFrame(_ node: ASDisplayNode, initial: Bool) -> CGRect {
        let first = initial ? initialFrame(for: node) : finalFrame(for: node)
        if first.isNull || first.isInfinite {
            let second = initial ? finalFrame(for: node) : initialFrame(for: node)
            if second.isNull || second.isInfinite {
                return .zero
            } else {
                return second
            }
        } else {
            return first
        }
    }
}

// MARK: - Animated subnodes

public extension ASContextTransitioning {
    
    public func animatedSubnodes() -> Set<ASDisplayNode> {
        return Set<ASDisplayNode>(subnodes(forKey: ASTransitionContextFromLayoutKey) + subnodes(forKey: ASTransitionContextToLayoutKey))
    }
}
