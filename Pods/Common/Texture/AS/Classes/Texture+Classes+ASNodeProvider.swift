import AsyncDisplayKit

// MARK: - ASNodeProvider

/// Универсальный провайдер
open class ASNodeProvider<T>: ASLayoutSpecProvider where T: ASDisplayNode {
    
    public let node: T
    
    /// Универсальная инициализация
    public init(node: T) {
        self.node = node
    }
    
    open var layoutSpec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: node)
    }
}

// MARK: - ASButtonNodeProvider

/// Провайдер ASButtonNode
public typealias ASButtonNodeProvider = ASNodeProvider<ASButtonNode>

public extension ASNodeProvider where T == ASButtonNode {
    
    /// Инициализация с ASButtonNode
    public convenience init() {
        self.init(node: ASButtonNode())
    }
}

// MARK: - ASDisplayNodeProvider

/// Провайдер ASDisplayNode
public typealias ASDisplayNodeProvider = ASNodeProvider<ASDisplayNode>

public extension ASNodeProvider where T == ASDisplayNode {
    
    /// Инициализация с ASDisplayNode
    public convenience init() {
        self.init(node: ASDisplayNode())
    }
}

// MARK: - ASImageNodeProvider

/// Провайдер ASImageNode
public typealias ASImageNodeProvider = ASNodeProvider<ASImageNode>

public extension ASNodeProvider where T == ASImageNode {
    
    /// Инициализация с ASImageNode
    public convenience init() {
        self.init(node: ASImageNode())
    }
}
