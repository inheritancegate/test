import AsyncDisplayKit
/// Провайдер угла. radius px x radius px
public class ASCornerNodeProvider: ASLayoutSpecProvider {
    
    private let path: CGPath
    private let provider = ASImageNodeProvider()
    private let radius: CGFloat
    
    public init(background: UIColor? = nil, corner: ASCorner, foreground: UIColor, radius: CGFloat) {
        self.path = corner.path(radius: radius)
        self.radius = radius
        self.provider.node.placeholderEnabled = true
        self.provider.node.placeholderColor = foreground
        self.provider.node.image = {
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
        self.provider.node.contentMode = .center
    }
    
    public var layoutSpec: ASLayoutSpec {
        let spec0 = provider.layoutSpec
        spec0.style.height = ASDimension(unit: ASDimensionUnit.points, value: radius)
        spec0.style.width = ASDimension(unit: ASDimensionUnit.points, value: radius)
        spec0.style.flexShrink = 0
        spec0.style.flexGrow = 0
        return spec0
    }
}
