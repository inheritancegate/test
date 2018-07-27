import AsyncDisplayKit
import Common

final class ControllerFullFlightConvenienceSpecProvider: ASLayoutSpecProvider {
    
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerConvenience = self.getProviderConvenience()
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerConvenience.layoutSpec
        let spec1 = ASStackLayoutSpec.horizontal(justifyContent: .start, alignItems: .center, children: [spec0])
        if LaunchArguments.debugColors.isEnabled {
            let spec2 = providerBackground.layoutSpec
            let spec3 = ASBackgroundLayoutSpec.with(elements: spec1, spec2)
            return spec3
        }
        return spec1
    }
}

extension ControllerFullFlightConvenienceSpecProvider {
    
    func set(attributedText: NSAttributedString?, image: UIImage?) {
        let icon = Icon(image: image, size: CGSize(width: 16, height: 16))
        providerConvenience.set(attributedText: attributedText, backgroundColor: .white, icon: icon, spacing: 4)
    }
}

private extension ControllerFullFlightConvenienceSpecProvider {
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        provider.set(backgroundColor: UIColor.green)
        return provider
    }
    
    func getProviderConvenience() -> SpecProviderImageText {
        let provider = SpecProviderImageText()
        return provider
    }
}
