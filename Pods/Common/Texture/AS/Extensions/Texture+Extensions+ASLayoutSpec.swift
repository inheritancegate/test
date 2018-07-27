import AsyncDisplayKit

public extension ASLayoutSpec {
    
    public static func getSpacer(height: CGFloat?, width: CGFloat?) -> ASLayoutSpec {
        let spec0 = ASLayoutSpec()
        if let height = height {
            spec0.style.height = ASDimension(unit: .points, value: height)
        }
        if let width = width {
            spec0.style.width = ASDimension(unit: .points, value: width)
        }
        return spec0
    }
    
    public static func getSpacer(height: CGFloat) -> ASLayoutSpec {
        return getSpacer(height: height, width: nil)
    }
    
    public static func getSpacer(width: CGFloat) -> ASLayoutSpec {
        return getSpacer(height: nil, width: width)
    }
}

