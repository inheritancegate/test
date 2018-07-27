import AsyncDisplayKit
/// Провайдер бэкграунда со скрулениями фиксированного радиуса
public class SpecProviderColorRounded: ASLayoutSpecProvider {
    
    private func provider(_ background: UIColor?, _ corner: Corners, _ corners: Corners, _ foreground: UIColor, _ radius: CGFloat) -> ASLayoutSpecProvider {
        switch corners.contains(corner) {
        case true:
            return SpecProviderCorner(background, corner, foreground, radius)
        default:
            let provider = SpecProviderColor()
            provider.node.backgroundColor = foreground
            provider.node.style.height = ASDimension(unit: ASDimensionUnit.points, value: radius)
            provider.node.style.width = ASDimension(unit: ASDimensionUnit.points, value: radius)
            provider.node.style.flexShrink = 0
            provider.node.style.flexGrow = 0
            return provider
        }
    }
    
    private func provider(_ foreground: UIColor) -> ASLayoutSpecProvider {
        let provider = SpecProviderColor()
        provider.node.backgroundColor = foreground
        return provider
    }
    
    private var bottomLeft: ASLayoutSpecProvider!
    private var bottomRight: ASLayoutSpecProvider!
    private var topLeft: ASLayoutSpecProvider!
    private var topRight: ASLayoutSpecProvider!
    
    private var horizontal: ASLayoutSpecProvider!
    private var vertical: ASLayoutSpecProvider!
    
    private lazy var radius: CGFloat = 0
    
    public init(background: UIColor? = nil, corners: Corners = .all, foreground: UIColor, radius: CGFloat) {
        bottomLeft = provider(background, .bottomLeft, corners, foreground, radius)
        bottomRight = provider(background, .bottomRight, corners, foreground, radius)
        topLeft = provider(background, .topLeft, corners, foreground, radius)
        topRight = provider(background, .topRight, corners, foreground, radius)
        horizontal = provider(foreground)
        vertical = provider(foreground)
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

