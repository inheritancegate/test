import AsyncDisplayKit
import Common

protocol SpecProviderImageControlDelegate: class {
    
    func specProviderImageControl(_ provider: SpecProviderImageControl, didReceiveTouchUpInsideEvent: Void)
}

final class SpecProviderImageControl: ASLayoutSpecProvider {
    
    weak var delegate: SpecProviderImageControlDelegate?
    private lazy var providerControl = self.getProviderControl()
    private lazy var providerIcon = self.getProviderIcon()
    private lazy var size: CGSize? = nil
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = providerControl.layoutSpec
        let spec1 = providerIcon.layoutSpec
        if let size = size {
            spec1.style.height = ASDimension(unit: .points, value: size.height)
            spec1.style.width = ASDimension(unit: .points, value: size.width)
        }
        let spec2 = ASOverlayLayoutSpec.with(elements: spec1, spec0)
        return spec2
    }
}

extension SpecProviderImageControl {
    
    func set(backgroundColor: UIColor?, hitTestSlop: UIEdgeInsets, icon: Icon) {
        providerControl.node.hitTestSlop = hitTestSlop
        providerControl.node.backgroundColor = backgroundColor
        providerIcon.node.backgroundColor = backgroundColor
        providerIcon.node.contentMode = icon.contentMode
        if let image = icon.image {
            providerIcon.node.image = image
        } else if let url = icon.url {
            providerIcon.node.url = url
        }
        size = icon.size
    }
}

// MARK: - Providers

private extension SpecProviderImageControl {
    
    @objc func didReceiveTouchUpInsideEvent() {
        delegate?.specProviderImageControl(self, didReceiveTouchUpInsideEvent: ())
    }
    
    func getProviderControl() -> ASNodeProvider<ASControlNode> {
        let node = ASControlNode()
        node.zPosition = -1
        node.addTarget(self, action: #selector(didReceiveTouchUpInsideEvent), forControlEvents: ASControlNodeEvent.touchUpInside)
        return ASNodeProvider(node: node)
    }
    
    func getProviderIcon() -> ASNodeProvider<ASNetworkImageNode> {
        let node = ASNetworkImageNode()
        node.contentMode = .center
        return ASNodeProvider(node: node)
    }
}
