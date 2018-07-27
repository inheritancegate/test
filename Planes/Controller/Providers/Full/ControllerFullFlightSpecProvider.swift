import AsyncDisplayKit
import Common

protocol ControllerFullFlightSpecProviderDelegate: class {
    
    func controllerFullFlightSpecProvider(_ provider: ControllerFullFlightSpecProvider, didReceiveTouchUpInsideEvent: Void)
}

final class ControllerFullFlightSpecProvider: ASLayoutSpecProvider {
    
    private lazy var conveniences: [(image: UIImage?, text: String)] = []
    weak var delegate: ControllerFullFlightSpecProviderDelegate?
    private lazy var providerDate = self.getProviderDate()
    private lazy var providersConvenience = self.getProvidersConvenience()
    private lazy var providerDirection = self.getProviderDirection()
    private lazy var providerDurationInterval = self.getProviderDurationInterval()
    private lazy var providerPlane = self.getProviderPlane()
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = providerDirection.layoutSpec
        let spec1 = providerDate.layoutSpec
        let spec2 = providerDurationInterval.layoutSpec
        let spec3 = providerPlane.layoutSpec
        let spec4 = ASStackLayoutSpec.vertical(
            justifyContent: .start,
            alignItems: .stretch,
            children: [spec0, spec1, spec2, ASLayoutSpec.getSpacer(height: 5)] + providersConvenience.map({ $0.layoutSpec }) + [ASLayoutSpec.getSpacer(height: 5), spec3]
        )
        return spec4
    }
}

extension ControllerFullFlightSpecProvider {
    
    func set(conveniences: [(image: UIImage?, text: String)], dateAttributedText: NSAttributedString?, directionAttributedText: NSAttributedString?, disclosure: Bool, durationAttributedText: NSAttributedString?, intervalAttributedText: NSAttributedString?, plane: (image: URL?, attributedText: NSAttributedString?)) {
        self.conveniences = conveniences
        providerDate.node.attributedText = dateAttributedText
        providerDirection.set(attributedText: directionAttributedText, disclosure: disclosure)
        providerDurationInterval.set(durationAttributedText: durationAttributedText, intervalAttributedText: intervalAttributedText)
        providerPlane.set(attributedText: plane.attributedText, backgroundColor: .white, icon: Icon(size: CGSize(width: 40, height: 20), url: plane.image), spacing: 4)
    }
}

extension ControllerFullFlightSpecProvider: ControllerFullFlightDirectionSpecProviderDelegate {
    
    func controllerFullFlightDirectionSpecProvider(_ provider: ControllerFullFlightDirectionSpecProvider, didReceiveTouchUpInsideEvent: Void) {
        delegate?.controllerFullFlightSpecProvider(self, didReceiveTouchUpInsideEvent: ())
    }
}

// MARK: - Providers

private extension ControllerFullFlightSpecProvider {
    
    func getProvidersConvenience() -> [ControllerFullFlightConvenienceSpecProvider] {
        return conveniences
            .map({ (convenience) -> ControllerFullFlightConvenienceSpecProvider in
                let provider = ControllerFullFlightConvenienceSpecProvider()
                let text = convenience.text
                let attributedText = NSAttributedString.with(color: .black, size: 13, text: text, weight: .semibold)
                provider.set(attributedText: attributedText, image: convenience.image)
                return provider
            })
    }
    
    func getProviderDate() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        if LaunchArguments.debugColors.isEnabled {
            node.backgroundColor = UIColor.cyan
        }
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }

    func getProviderDirection() -> ControllerFullFlightDirectionSpecProvider {
        let provider = ControllerFullFlightDirectionSpecProvider()
        provider.delegate = self
        return provider
    }
    
    func getProviderDurationInterval() -> ControllerFullFlightDurationIntervalSpecProvider {
        let provider = ControllerFullFlightDurationIntervalSpecProvider()
        return provider
    }
    
    func getProviderPlane() -> SpecProviderImageText {
        let provider = SpecProviderImageText()
        return provider
    }
}
