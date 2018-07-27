import AsyncDisplayKit

public extension ASOverlayLayoutSpec {
    /// Первый - самый глубокий. Размеры считаются на базе первого элемента
    public static func with(elements: ASLayoutElement...) -> ASLayoutSpec {
        return with(elements: elements)
    }
    /// Первый - самый глубокий. Размеры считаются на базе первого элемента
    public static func with(elements: [ASLayoutElement]) -> ASLayoutSpec {
        switch elements.count {
        case 1:
            return ASWrapperLayoutSpec(layoutElement: elements[0])
        case 2...:
            let spec = ASOverlayLayoutSpec(child: elements[0], overlay: elements[1])
            return ASOverlayLayoutSpec.with(elements: [spec] + [ASLayoutElement](elements.dropFirst(2)))
        default:
            return ASLayoutSpec()
        }
    }
}
