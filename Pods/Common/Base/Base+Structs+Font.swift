import UIKit
//@available(iOS 9.0, *)
public struct Font {
    
    public enum Trait {
        
        case bold
        case italic
        
        var value: UIFontDescriptorSymbolicTraits {
            switch self {
            case .bold:
                return UIFontDescriptorSymbolicTraits.traitBold
            case .italic:
                return UIFontDescriptorSymbolicTraits.traitItalic
            }
        }
    }
    
    public enum Style {
        
        case body
        case callout
        case caption1
        case caption2
        case footnote
        case headline
        case largeTitle
        case subheadline
        case title1
        case title2
        case title3
        
        var value: UIFontTextStyle {
            switch self {
            case .body:
                return UIFontTextStyle.body
            case .callout:
                if #available(iOS 9.0, *) {
                    return UIFontTextStyle.callout
                } else {
                    return UIFontTextStyle.body
                }
            case .caption1:
                return UIFontTextStyle.caption1
            case .caption2:
                return UIFontTextStyle.caption2
            case .footnote:
                return UIFontTextStyle.footnote
            case .headline:
                return UIFontTextStyle.headline
            case .largeTitle:
                if #available(iOS 11.0, *) {
                    return UIFontTextStyle.largeTitle
                } else {
                    return UIFontTextStyle.body
                }
            case .subheadline:
                return UIFontTextStyle.subheadline
            case .title1:
                if #available(iOS 9.0, *) {
                    return UIFontTextStyle.title1
                } else {
                    return UIFontTextStyle.body
                }
            case .title2:
                if #available(iOS 9.0, *) {
                    return UIFontTextStyle.title2
                } else {
                    return UIFontTextStyle.body
                }
            case .title3:
                if #available(iOS 9.0, *) {
                    return UIFontTextStyle.title3
                } else {
                    return UIFontTextStyle.body
                }
            }
        }
    }
    
    public static func with(style: Font.Style) -> UIFont {
        return UIFont.preferredFont(forTextStyle: style.value)
    }
}

public extension UIFont {
    
    public func with(traits: Font.Trait...) -> UIFont {
        let symbolicTraits = traits.dropFirst().reduce(traits[0].value, { (value, trait) -> UIFontDescriptorSymbolicTraits in
            return [value, trait.value]
        })
        if let descriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) {
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return self
        }
    }
}
