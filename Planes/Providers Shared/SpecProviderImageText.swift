import AsyncDisplayKit
import Common

class SpecProviderImageText: ASLayoutSpecProvider {
    
    private lazy var insets = UIEdgeInsets.zero
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerIcon = self.getProviderIcon()
    private lazy var providerText = self.getProviderText()
    private lazy var size: CGSize? = nil
    private lazy var spacing: CGFloat = 0
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerText.layoutSpec
        let spec1 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .stretch, children: [spec0])
        spec1.style.flexShrink = 1
        let spec2 = providerIcon.layoutSpec
        if let size = size {
            spec2.style.height = ASDimension(unit: .points, value: size.height)
            spec2.style.width = ASDimension(unit: .points, value: size.width)
        }
        let spec3 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .stretch, children: [spec2])
        let spec4 = ASStackLayoutSpec.horizontal(justifyContent: .start, alignItems: .center, children: [spec3, spec1], spacing: spacing)
        let spec5 = ASInsetLayoutSpec(insets: insets, child: spec4)
        let spec6 = providerBackground.layoutSpec
        let spec7 = ASBackgroundLayoutSpec.with(elements: spec5, spec6)
        return spec7
    }
    
    var layoutNodes: [ASDisplayNode] {
        return [providerText.node]
    }
}

extension SpecProviderImageText {
    
    func set(attributedText: NSAttributedString?, backgroundColor: UIColor, corners: Corners? = nil, icon: Icon, insets: UIEdgeInsets = .zero, spacing: CGFloat) {
        self.insets = insets
        self.providerBackground.set(backgroundColor: backgroundColor, corners: corners)
        self.providerIcon.node.backgroundColor = backgroundColor
        self.providerIcon.node.contentMode = icon.contentMode
        if let image = icon.image {
            self.providerIcon.node.image = image
        } else if let url = icon.url {
            self.providerIcon.node.url = url
        }
        self.providerText.node.attributedText = attributedText
        self.providerText.node.backgroundColor = backgroundColor
        self.size = icon.size
        self.spacing = spacing
    }
}

// MARK: - Providers

private extension SpecProviderImageText {
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        return provider
    }
    
    func getProviderIcon() -> ASNodeProvider<ASNetworkImageNode> {
        let node = ASNetworkImageNode()
        return ASNodeProvider(node: node)
    }
    
    func getProviderText() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        let provider = ASNodeProvider(node: node)
        return provider
    }
}
