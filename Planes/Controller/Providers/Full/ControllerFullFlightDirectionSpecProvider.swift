import AsyncDisplayKit
import Common

protocol ControllerFullFlightDirectionSpecProviderDelegate: class {

    func controllerFullFlightDirectionSpecProvider(_ provider: ControllerFullFlightDirectionSpecProvider, didReceiveTouchUpInsideEvent: Void)
}

final class ControllerFullFlightDirectionSpecProvider: ASLayoutSpecProvider {
    
    weak var delegate: ControllerFullFlightDirectionSpecProviderDelegate?
    private lazy var disclosure: Bool = false
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerDirection = self.getProviderDirection()
    private lazy var providerDisclosure = self.getProviderDisclosure()
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = layoutSpecContent
        if LaunchArguments.debugColors.isEnabled {
            let spec1 = providerBackground.layoutSpec
            let spec2 = ASBackgroundLayoutSpec.with(elements: spec0, spec1)
            return spec2
        }
        return spec0
    }
    
    private var layoutSpecContent: ASLayoutSpec {
        switch disclosure {
        case true:
            let spec0 = providerDirection.layoutSpec
            spec0.style.width = ASDimension(unit: .fraction, value: 1)
            spec0.style.flexShrink = 1
            let spec1 = providerDisclosure.layoutSpec
            spec1.style.height = ASDimension(unit: .points, value: 16)
            spec1.style.width = ASDimension(unit: .points, value: 16)
            let spec2 = ASStackLayoutSpec.horizontal(
                justifyContent: .spaceBetween,
                alignItems: .center,
                children: [
                    spec0,
                    spec1
                ],
                spacing: 4
            )
            return spec2
        case false:
            let spec0 = providerDirection.layoutSpec
            return spec0
        }
    }
}

extension ControllerFullFlightDirectionSpecProvider {
    
    func set(attributedText: NSAttributedString?, disclosure: Bool) {
        self.disclosure = disclosure
        self.providerDirection.node.attributedText = attributedText
    }
}

extension ControllerFullFlightDirectionSpecProvider: SpecProviderImageControlDelegate {
    
    func specProviderImageControl(_ provider: SpecProviderImageControl, didReceiveTouchUpInsideEvent: Void) {
        delegate?.controllerFullFlightDirectionSpecProvider(self, didReceiveTouchUpInsideEvent: ())
    }
}

// MARK: - Providers

private extension ControllerFullFlightDirectionSpecProvider {
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        provider.set(backgroundColor: UIColor.purple)
        return provider
    }
    
    func getProviderDirection() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
    
    func getProviderDisclosure() -> SpecProviderImageControl {
        let provider = SpecProviderImageControl()
        provider.delegate = self
        var backgroundColor: UIColor = .white
        if LaunchArguments.debugColors.isEnabled {
            backgroundColor = .yellow
        }
        let hitTestSlop = UIEdgeInsets(bottom: -20, left: -20, right: -20, top: -20)
        let icon = Icon(image: UIImage(named: "ic_up"))
        provider.set(backgroundColor: backgroundColor, hitTestSlop: hitTestSlop, icon: icon)
        return provider
    }
}
