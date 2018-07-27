import Common
import CoreGraphics
import Foundation
import UIKit

extension NSAttributedString {
    ///
    enum Height {
        /// Принудительно установить высоту строки
        case force(CGFloat)
        /// Использовать высоту строки дефолтную для шрифта
        case normal
    }
    /// Расположение текста относительно контейнера, значение для смещения вверх
    enum Position {
        case bottom(CGFloat)
        case center(CGFloat)
        case top(CGFloat)
    }
    /// String
    static func with(attributes: [NSAttributedStringKey: Any] = [:], color: UIColor, height: Height = .normal, position: Position = .center(0), size: CGFloat, text: String?, weight: UIFont.Weight) -> NSAttributedString? {
        guard let string = text else {
            return nil
        }
        var attributes = attributes
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let lineHeight = getLineHeight(font: font, height: height, size: size)
        let lineOffset = getLineOffset(font: font, height: height, position: position, size: size)
        let paragraphStyle = getParagraphStyle(lineHeight: lineHeight)
        attributes[.baselineOffset] = lineOffset
        attributes[.font] = font
        attributes[.foregroundColor] = color
        attributes[.paragraphStyle] = paragraphStyle
        return NSAttributedString(string: string, attributes: attributes)
    }
}

private extension NSAttributedString {
    ///
    private static func getLineOffset(font: UIFont, height: Height, position: Position, size: CGFloat) -> CGFloat {
        let height = getLineHeight(font: font, height: height, size: size)
        switch position {
        case .bottom(let offset):
            return offset
        case .center(let offset):
            let missingOffset = (height - font.lineHeight) / 2
            return offset + missingOffset
        case .top(let offset):
            let missingOffset = height - font.lineHeight
            return offset + missingOffset
        }
    }
    ///
    private static func getLineHeight(font: UIFont, height: Height, size: CGFloat) -> CGFloat {
        let defaultLineHeight = ceil(font.lineHeight)
        switch height {
        case .force(let height):
            return height >= defaultLineHeight ? height : defaultLineHeight
        case .normal:
            return defaultLineHeight
        }
    }
    ///
    static func getParagraphStyle(lineHeight: CGFloat) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.0001
        paragraphStyle.maximumLineHeight = lineHeight + 0.0001
        paragraphStyle.minimumLineHeight = lineHeight - 0.0001
        return paragraphStyle
    }
}
