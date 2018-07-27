import AsyncDisplayKit
/// Провайдер бэкграунда со скруглениями фиксированного радиуса
public class ASCornersNodeProvider: ASLayoutSpecProvider {
    
    private func provider(_ background: UIColor?, _ corner: ASCorner, _ corners: [ASCorner], _ foreground: UIColor, _ radius: CGFloat) -> ASLayoutSpecProvider {
        switch corners.contains(corner) {
        case false:
            let provider = ASDisplayNodeProvider()
            provider.node.backgroundColor = foreground
            provider.node.style.height = ASDimension(unit: ASDimensionUnit.points, value: radius)
            provider.node.style.width = ASDimension(unit: ASDimensionUnit.points, value: radius)
            provider.node.style.flexShrink = 0
            provider.node.style.flexGrow = 0
            return provider
        default:
            let provider = ASCornerNodeProvider(background: background, corner: corner, foreground: foreground, radius: radius)
            return provider
        }
    }
    
    private func provider(_ foreground: UIColor) -> ASLayoutSpecProvider {
        let provider = ASDisplayNodeProvider()
        provider.node.backgroundColor = foreground
        return provider
    }
    
    private lazy var background: UIColor? = nil
    private lazy var corners: [ASCorner] = []
    private lazy var foreground: UIColor = .white
    private lazy var radius: CGFloat = 0
    
    private lazy var bottomLeft: ASLayoutSpecProvider = self.provider(background, .bottomLeft, corners, foreground, radius)
    private lazy var bottomRight: ASLayoutSpecProvider = self.provider(background, .bottomRight, corners, foreground, radius)
    private lazy var topLeft: ASLayoutSpecProvider = self.provider(background, .topLeft, corners, foreground, radius)
    private lazy var topRight: ASLayoutSpecProvider = self.provider(background, .topRight, corners, foreground, radius)
    
    private lazy var horizontal: ASLayoutSpecProvider = self.provider(foreground)
    private lazy var vertical: ASLayoutSpecProvider = self.provider(foreground)
    
    public convenience init(background: UIColor? = nil, corners: ASCorner..., foreground: UIColor, radius: CGFloat) {
        self.init(background: background, corners: corners, foreground: foreground, radius: radius)
    }
    
    public init(background: UIColor? = nil, corners: [ASCorner] = [.bottomLeft, .bottomRight, .topLeft, .topRight], foreground: UIColor, radius: CGFloat) {
        self.background = background
        self.corners = corners
        self.foreground = foreground
        self.radius = radius
    }
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: .minimumSize, child: bottomLeft.layoutSpec)
        let spec1 = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumSize, child: bottomRight.layoutSpec)
        let spec2 = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: topLeft.layoutSpec)
        let spec3 = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: .minimumSize, child: topRight.layoutSpec)
        let spec4 = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 0, left: radius, bottom: 0, right: radius), child: vertical.layoutSpec)
        let spec5 = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: radius, left: 0, bottom: radius, right: 0), child: horizontal.layoutSpec)
        for spec in [spec0, spec1, spec2, spec3, spec4, spec5] {
            spec.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
            spec.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        }
        let spec6 = ASBackgroundLayoutSpec.with(elements: [spec0, spec1, spec2, spec3, spec4, spec5])
        spec6.style.height = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        spec6.style.width = ASDimension(unit: ASDimensionUnit.fraction, value: 1)
        return spec6
    }
}
