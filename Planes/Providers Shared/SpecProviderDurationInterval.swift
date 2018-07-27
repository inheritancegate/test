import AsyncDisplayKit
import Common

class SpecProviderDurationInterval: ASLayoutSpecProvider {
    
    private lazy var providerDuration = self.getProviderDuration()
    private lazy var providerInterval = self.getProviderInterval()
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerInterval.layoutSpec
        let spec1 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .stretch, children: [spec0])
        spec1.style.flexShrink = 1
        let spec2 = providerDuration.layoutSpec
        let spec3 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .stretch, children: [spec2])
        let spec4 = ASStackLayoutSpec.horizontal(justifyContent: .start, alignItems: .center, children: [spec1, spec3], spacing: 8)
        spec4.style.flexShrink = 1
        return spec4
    }
}

extension SpecProviderDurationInterval {

    func set(durationAttributedText: NSAttributedString?, intervalAttributedText: NSAttributedString?) {
        providerDuration.set(
            attributedText: durationAttributedText,
            backgroundColor: UIColor(white: 0.75, alpha: 1.0),
            corners: Corners(color: .white, radius: 6),
            icon: Icon(image: UIImage(named: "ic_clock"), size: CGSize(width: 12, height: 12)),
            insets: UIEdgeInsets(bottom: 2, left: 4, right: 4, top: 2),
            spacing: 4
        )
        providerInterval.node.attributedText = intervalAttributedText
    }
}

// MARK: - Providers

private extension SpecProviderDurationInterval {
    
    func getProviderDuration() -> SpecProviderImageText {
        let provider = SpecProviderImageText()
        return provider
    }
    
    func getProviderInterval() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.backgroundColor = UIColor.white
        if LaunchArguments.debugColors.isEnabled {
            node.backgroundColor = UIColor.yellow
        }
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
}
