import AsyncDisplayKit
import Common

protocol ControllerShortDurationIntervalSpecProviderDelegate: class {
    
    func controllerShortDurationIntervalSpecProvider(_ provider: ControllerShortDurationIntervalSpecProvider, didReceiveTouchUpInsideEvent: Void)
}

final class ControllerShortDurationIntervalSpecProvider: ASLayoutSpecProvider {
    
    weak var delegate: ControllerShortDurationIntervalSpecProviderDelegate?
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerDisclosure = self.getProviderDisclosure()
    private lazy var providerDurationInterval = self.getProviderDurationInterval()
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerDurationInterval.layoutSpec
        let spec1 = providerDisclosure.layoutSpec
        spec1.style.height = ASDimension(unit: .points, value: 16)
        spec1.style.width = ASDimension(unit: .points, value: 16)
        let spec2 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .stretch, children: [spec1])
        let spec3 = ASStackLayoutSpec.horizontal(justifyContent: .spaceBetween, alignItems: .center, children: [spec0, spec2], spacing: 8)
        spec3.style.width = ASDimension(unit: .fraction, value: 1)
        spec3.style.flexShrink = 1
        if LaunchArguments.debugColors.isEnabled {
            let spec4 = providerBackground.layoutSpec
            let spec5 = ASBackgroundLayoutSpec.with(elements: spec3, spec4)
            spec5.style.flexShrink = 1
            return spec5
        }
        return spec3
    }
}

extension ControllerShortDurationIntervalSpecProvider {
    
    func set(durationAttributedText: NSAttributedString?, intervalAttributedText: NSAttributedString?) {
        providerDurationInterval.set(durationAttributedText: durationAttributedText, intervalAttributedText: intervalAttributedText)
    }
}

extension ControllerShortDurationIntervalSpecProvider: SpecProviderImageControlDelegate {
    
    func specProviderImageControl(_ provider: SpecProviderImageControl, didReceiveTouchUpInsideEvent: Void) {
        delegate?.controllerShortDurationIntervalSpecProvider(self, didReceiveTouchUpInsideEvent: ())
    }
}

// MARK: - Providers

private extension ControllerShortDurationIntervalSpecProvider {
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        provider.set(backgroundColor: UIColor.cyan)
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
        let icon = Icon(image: UIImage(named: "ic_down"))
        provider.set(backgroundColor: backgroundColor, hitTestSlop: hitTestSlop, icon: icon)
        return provider
    }
    
    func getProviderDurationInterval() -> SpecProviderDurationInterval {
        let provider = SpecProviderDurationInterval()
        return provider
    }
}
