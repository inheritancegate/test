import AsyncDisplayKit

public protocol ASLayoutSpecProvider: class {
    ///
    var layoutNodes: [ASDisplayNode] { get }
    ///
    var layoutSpec: ASLayoutSpec { get }
}

extension ASLayoutSpecProvider {
    
    public var layoutNodes: [ASDisplayNode] {
        return []
    }
}
