import AsyncDisplayKit
/// Провайдер ASImageNode изображения 100% x 100%
public class SpecProviderImage: ASLayoutSpecProvider {
    
    public private(set) lazy var node: ASImageNode = self.getNode()
    
    private func getNode() -> ASImageNode {
        let node = ASImageNode()
        node.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        node.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        return node
    }
    
    public var layoutSpec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: node)
    }
}

public class SpecProvider<T>: ASLayoutSpecProvider where T: ASDisplayNode {
    
    public let node: T
    
    public init(node: T) {
        self.node = node
    }

    public var layoutSpec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: node)
    }
}
