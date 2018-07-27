import AsyncDisplayKit
import Common

final class ControllerShortDetailsSpecProvider: ASLayoutSpecProvider {
    
    private lazy var providerAirline = self.getProviderAirline()
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerIcon = self.getProviderIcon()
    private lazy var providerMatch = self.getProviderMatch()
    private lazy var providerPrice = self.getProviderPrice()
    private lazy var providerPriceBackground = self.getProviderPriceBackground()
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = layoutSpecPrice
        let spec1 = providerMatch.layoutSpec
        let spec2 = providerAirline.layoutSpec
        spec2.style.flexShrink = 1
        spec2.style.flexGrow = 1
        let spec3 = providerIcon.layoutSpec
        spec3.style.height = ASDimension(unit: .points, value: 20)
        spec3.style.width = ASDimension(unit: .points, value: 40)
        let spec4 = ASStackLayoutSpec.horizontal(justifyContent: .spaceBetween, alignItems: .center, children: [spec3, spec2, spec1, spec0], spacing: 4)
        if LaunchArguments.debugColors.isEnabled {
            let spec5 = providerBackground.layoutSpec
            let spec6 = ASBackgroundLayoutSpec.with(elements: spec4, spec5)
            return spec6
        }
        return spec4
    }
    
    private var layoutSpecPrice: ASLayoutSpec {
        let spec0 = providerPrice.layoutSpec
        let spec1 = ASInsetLayoutSpec(insets: UIEdgeInsets(left: 16, right: 16), child: spec0)
        let spec2 = ASStackLayoutSpec.vertical(justifyContent: .center, alignItems: .center, children: [spec1])
        spec2.style.height = ASDimension(unit: .points, value: 32)
        spec2.style.minWidth = ASDimension(unit: .points, value: 32)
        let spec3 = providerPriceBackground.layoutSpec
        let spec4 = ASBackgroundLayoutSpec.with(elements: spec2, spec3)
        return spec4
    }
}

extension ControllerShortDetailsSpecProvider {
    
    func set(airlineAttributedText: NSAttributedString?, image: URL?, matchAttributedText: NSAttributedString?, priceAttributedText: NSAttributedString?, priceBorderColor: UIColor) {
        providerAirline.node.attributedText = airlineAttributedText
        providerIcon.node.url = image
        var backgroundColor: UIColor = .white
        if LaunchArguments.debugColors.isEnabled {
            backgroundColor = .yellow
        }
        providerMatch.set(
            attributedText: matchAttributedText,
            backgroundColor: backgroundColor,
            icon: Icon(image: UIImage(named: "ic_like"), size: CGSize(width: 12, height: 12)),
            spacing: 4
        )
        providerPrice.node.attributedText = priceAttributedText
        providerPriceBackground.set(
            backgroundColor: .white,
            border: Border(color: priceBorderColor, width: 1),
            corners: Corners(color: .white, radius: 16)
        )
    }

//    var priceText: (color: UIColor, string: String)? {
//        get {
//            return providerPrice.text
//        }
//        set {
//            providerPrice.text = newValue
//        }
//    }
}


// MARK: - Providers

private extension ControllerShortDetailsSpecProvider {
    
    func getProviderAirline() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
    
    func getProviderBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        provider.set(backgroundColor: UIColor.brown)
        return provider
    }
    
    func getProviderIcon() -> ASNodeProvider<ASNetworkImageNode> {
        let node = ASNetworkImageNode()
        node.backgroundColor = UIColor.black
        node.contentMode = .scaleAspectFill
        return ASNodeProvider(node: node)
    }
    
    func getProviderMatch() -> SpecProviderImageText {
        let provider = SpecProviderImageText()
        return provider
    }
    
    func getProviderPrice() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
    
    func getProviderPriceBackground() -> SpecProviderBackground {
        let provider = SpecProviderBackground()
        return provider
    }
}
