import AsyncDisplayKit
/// Провайдер ASDisplayNode для перекрашивания 100% x 100%
public class SpecProviderColor: ASLayoutSpecProvider {
    
    public private(set) lazy var node: ASDisplayNode = self.getNode()
    
    public init(color: UIColor? = nil) {
        self.node.backgroundColor = color
    }
    
    private func getNode() -> ASDisplayNode {
        let node = ASDisplayNode()
        node.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        node.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        return node
    }
    
    public var layoutSpec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: node)
    }
}

public class SpecProviderBorder: ASLayoutSpecProvider {
    
    public lazy var insets: UIEdgeInsets = .zero
    
    let bottom1: SpecProviderColor
    let left1: SpecProviderColor
    let right1: SpecProviderColor
    let top1: SpecProviderColor
    
    let bottom2: SpecProviderColor
    let left2: SpecProviderColor
    let right2: SpecProviderColor
    let top2: SpecProviderColor
    
    public init(color: UIColor, insets: UIEdgeInsets = .zero) {
        bottom1 = SpecProviderColor(color: color)
        left1 = SpecProviderColor(color: color)
        right1 = SpecProviderColor(color: color)
        top1 = SpecProviderColor(color: color)
        
        bottom2 = SpecProviderColor(color: color)
        left2 = SpecProviderColor(color: color)
        right2 = SpecProviderColor(color: color)
        top2 = SpecProviderColor(color: color)
    }
    
    public var layoutSpec: ASLayoutSpec {
        return ASBackgroundLayoutSpec.with(elements: layoutSpecBottom, layoutSpecLeft, layoutSpecRight, layoutSpecTop)
    }
    
    struct Object1 {
        
        let height: ASDimension
        let horizontal: ASRelativeLayoutSpecPosition
        let spec: ASLayoutSpec
        let value: CGFloat
        let vertical: ASRelativeLayoutSpecPosition
        let width: ASDimension
        
        static func horizontal(position: ASRelativeLayoutSpecPosition, spec: ASLayoutSpec, value: CGFloat) -> Object1 {
            let height = ASDimension(unit: .fraction, value: 1)
            let width = ASDimension(unit: .points, value: value)
            return Object1(height: height, horizontal: position, spec: spec, value: value, vertical: .center, width: width)
        }
        
        static func vertical(position: ASRelativeLayoutSpecPosition, spec: ASLayoutSpec, value: CGFloat) -> Object1 {
            let height = ASDimension(unit: .points, value: value)
            let width = ASDimension(unit: .fraction, value: 1)
            return Object1(height: height, horizontal: .center, spec: spec, value: value, vertical: position, width: width)
        }
        
        var layoutSpec: ASLayoutSpec {
            if value > 0 {
                let spec0 = spec
                spec0.style.height = height
                spec0.style.width = width
                let spec1 = ASRelativeLayoutSpec(horizontalPosition: horizontal, verticalPosition: vertical, sizingOption: .minimumSize, child: spec0)
                spec1.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
                spec1.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
                return spec1
            } else {
                return ASLayoutSpec()
            }
        }
    }
    
    struct Object2 {
        
        let direction: ASStackLayoutDirection
        let justifyContent: ASStackLayoutJustifyContent
        let spec: ASLayoutSpec
        
        static func horizontal(justifyContent: ASStackLayoutJustifyContent, spec: ASLayoutSpec) -> Object2 {
            return Object2(direction: .horizontal, justifyContent: justifyContent, spec: spec)
        }
        
        static func vertical(justifyContent: ASStackLayoutJustifyContent, spec: ASLayoutSpec) -> Object2 {
            return Object2(direction: .vertical, justifyContent: justifyContent, spec: spec)
        }
        
        var layoutSpec: ASLayoutSpec {
            let spec0 = spec
            spec0.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            spec0.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            let spec1 = ASLayoutSpec()
            spec1.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            spec1.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            let spec2 = ASStackLayoutSpec(direction: direction, spacing: 0, justifyContent: justifyContent, alignItems: .stretch, children: justifyContent == .start ? [spec1, spec0] : [spec0, spec1])
            spec2.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            spec2.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            return spec2
        }
    }
    
    var layoutSpecBottom: ASLayoutSpec {
        let spec1 = Object1.vertical(position: .end, spec: bottom1.layoutSpec, value: insets.bottom).layoutSpec
        let spec2 = Object2.vertical(justifyContent: .start, spec: bottom2.layoutSpec).layoutSpec
        return ASBackgroundLayoutSpec.with(elements: spec1, spec2)
    }
    
    var layoutSpecLeft: ASLayoutSpec {
        let spec1 = Object1.horizontal(position: .start, spec: left1.layoutSpec, value: insets.left).layoutSpec
        let spec2 = Object2.horizontal(justifyContent: .end, spec: left2.layoutSpec).layoutSpec
        return ASBackgroundLayoutSpec.with(elements: spec1, spec2)
    }
    
    var layoutSpecRight: ASLayoutSpec {
        let spec1 = Object1.horizontal(position: .end, spec: right1.layoutSpec, value: insets.right).layoutSpec
        let spec2 = Object2.horizontal(justifyContent: .start, spec: right2.layoutSpec).layoutSpec
        return ASBackgroundLayoutSpec.with(elements: spec1, spec2)
    }
    
    var layoutSpecTop: ASLayoutSpec {
        let spec1 = Object1.vertical(position: .start, spec: top1.layoutSpec, value: insets.top).layoutSpec
        let spec2 = Object2.vertical(justifyContent: .end, spec: top2.layoutSpec).layoutSpec
        return ASBackgroundLayoutSpec.with(elements: spec1, spec2)
    }
}
