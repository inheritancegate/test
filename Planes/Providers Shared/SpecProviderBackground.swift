import AsyncDisplayKit
import Common

final class SpecProviderBackground: ASLayoutSpecProvider {
    
    private lazy var corners: Bool = false
    private lazy var providerPlain = self.getProviderPlain()
    private lazy var providerImage = self.getProviderImage()

    public var layoutSpec: ASLayoutSpec {
        switch corners {
        case true:
            return providerImage.layoutSpec
        case false:
            return providerPlain.layoutSpec
        }
    }
}

extension SpecProviderBackground {
    
    func set(backgroundColor: UIColor, border: Border? = nil, corners: Corners? = nil) {
        self.corners = corners != nil
        switch corners {
        case .some(let corners):
            let foreground = backgroundColor
            let cap = Int(corners.radius)
            switch border {
            case .some(let border):
                providerImage.node.image = UIImage.with(background: corners.color, border: border, foreground: foreground, radius: corners.radius)?.stretchableImage(withLeftCapWidth: cap, topCapHeight: cap)
            case .none:
                providerImage.node.image = UIImage.with(background: corners.color, foreground: foreground, radius: corners.radius)?.stretchableImage(withLeftCapWidth: cap, topCapHeight: cap)
            }
        case .none:
            providerPlain.node.backgroundColor = backgroundColor
        }
    }
}

// MARK: - Providers

private extension SpecProviderBackground {
    
    func getProviderPlain() -> ASNodeProvider<ASDisplayNode> {
        let node = ASDisplayNode()
        return ASNodeProvider(node: node)
    }
    
    func getProviderImage() -> ASNodeProvider<ASImageNode> {
        let node = ASImageNode()
        return ASNodeProvider(node: node)
    }
}
