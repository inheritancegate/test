import AsyncDisplayKit

public class SpecProviderButton: ASLayoutSpecProvider {
    
    public private(set) lazy var node: ASButtonNode = self.getNode()
    
    public init() {
        //
    }
    
    private func getNode() -> ASButtonNode {
        let node = ASButtonNode()
//        node.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
//        node.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        return node
    }
    
    public var layoutSpec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: node)
    }
}
