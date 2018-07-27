import AsyncDisplayKit

public extension ASBackgroundLayoutSpec {
    /// Первый - самый верхний. Размеры считаются на базе первого элемента
    public static func with(elements: ASLayoutElement...) -> ASLayoutSpec {
        return with(elements: elements)
    }
    /// Первый - самый верхний. Размеры считаются на базе первого элемента
    public static func with(elements: [ASLayoutElement]) -> ASLayoutSpec {
        switch elements.count {
        case 1:
            return ASWrapperLayoutSpec(layoutElement: elements[0])
        case 2...:
            let spec = ASBackgroundLayoutSpec(child: elements[0], background: elements[1])
            return ASBackgroundLayoutSpec.with(elements: [spec] + [ASLayoutElement](elements.dropFirst(2)))
        default:
            return ASLayoutSpec()
        }
    }
}
