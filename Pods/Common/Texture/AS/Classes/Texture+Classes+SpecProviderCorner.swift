import AsyncDisplayKit
/// провайдер угла. radius px x radius px
public class SpecProviderCorner: ASLayoutSpecProvider {
    
    private let path: CGPath?
    private lazy var provider = SpecProviderImage()
    private lazy var radius: CGFloat = 0
    
    public init(_ background: UIColor? = nil, _ corners: Corners, _ foreground: UIColor, _ radius: CGFloat) {
        self.path = corners.path(radius: radius)
        self.radius = radius
        self.provider.node.placeholderEnabled = true
        self.provider.node.placeholderColor = foreground
        if let path = self.path {
            provider.node.image = {
                let size = CGSize(width: radius, height: radius)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                let context = UIGraphicsGetCurrentContext()
                if let background = background {
                    let rect = CGRect(origin: .zero, size: size)
                    context?.setFillColor(background.cgColor)
                    context?.fill(rect)
                }
                context?.addPath(path)
                context?.setFillColor(foreground.cgColor)
                context?.closePath()
                context?.fillPath()
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
            }()
            provider.node.contentMode = .center
        }
    }
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = path != nil ? provider.layoutSpec : ASLayoutSpec()
        spec0.style.height = ASDimension(unit: ASDimensionUnit.points, value: radius)
        spec0.style.width = ASDimension(unit: ASDimensionUnit.points, value: radius)
        spec0.style.flexShrink = 0
        spec0.style.flexGrow = 0
        return spec0
    }
}
