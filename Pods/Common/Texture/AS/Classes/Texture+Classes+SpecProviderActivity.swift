import AsyncDisplayKit

public class SpecProviderActivity: ASLayoutSpecProvider {
    
    public let node: ASActivityNode
    
    public init(completion: ((UIActivityIndicatorView?) -> ())?) {
        self.node = ASActivityNode(completion: completion)
    }
    
    public var layoutSpec: ASLayoutSpec {
        return ASRelativeLayoutSpec(horizontalPosition: .center, verticalPosition: .center, sizingOption: .minimumSize, child: node)
    }
}
