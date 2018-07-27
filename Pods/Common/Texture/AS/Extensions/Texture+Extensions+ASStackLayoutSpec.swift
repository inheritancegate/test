import AsyncDisplayKit

public extension ASStackLayoutSpec {
    
    public static func horizontal(justifyContent: ASStackLayoutJustifyContent, alignItems: ASStackLayoutAlignItems, children: [ASLayoutElement], spacing: CGFloat = 0) -> ASStackLayoutSpec {
        return ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: justifyContent, alignItems: alignItems, children: children)
    }
    
    public static func vertical(justifyContent: ASStackLayoutJustifyContent, alignItems: ASStackLayoutAlignItems, children: [ASLayoutElement], spacing: CGFloat = 0) -> ASStackLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical, spacing: spacing, justifyContent: justifyContent, alignItems: alignItems, children: children)
    }
}
