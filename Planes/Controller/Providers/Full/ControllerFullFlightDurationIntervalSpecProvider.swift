import AsyncDisplayKit
import Common

final class ControllerFullFlightDurationIntervalSpecProvider: SpecProviderDurationInterval {
    
    private lazy var providerBackground = self.getProviderBackground()
    
    override var layoutSpec: ASLayoutSpec {
        let spec0 = super.layoutSpec
        if LaunchArguments.debugColors.isEnabled {
            let spec1 = providerBackground.layoutSpec
            let spec2 = ASBackgroundLayoutSpec.with(elements: spec0, spec1)
            spec2.style.flexShrink = 1
            return spec2
        }
        return spec0
    }
}

private extension ControllerFullFlightDurationIntervalSpecProvider {
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        provider.set(backgroundColor: UIColor.orange)
        return provider
    }
}
