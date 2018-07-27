import Foundation

public extension String {
    
    /// Локализованная строка без комментария
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

public extension String {

    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var removeHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

fileprivate let formatter: NumberFormatter = getFormatter()
fileprivate func getFormatter() -> NumberFormatter {
    let _formatter = NumberFormatter()
    _formatter.generatesDecimalNumbers = true
    return _formatter
}

public extension String {
    
    private var toDouble: String? {
        if let number = formatter.number(from: replacingOccurrences(of: ".", with: ",")) as? NSDecimalNumber {
            return number.doubleValue.description
        } else if let number = formatter.number(from: replacingOccurrences(of: ",", with: ".")) as? NSDecimalNumber {
            return number.doubleValue.description
        } else {
            return nil
        }
    }

    private var toInteger: String? {
        if let integer = Int(self), String(integer) == self {
            return self
        } else {
            return nil
        }
    }
    
    public var toNumber: String? {
        return toInteger ?? toDouble
    }
    // Конвертация строки в целое число
    public var toInt: Int? {
        return Int(self)
    }
}

public extension String {
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension NSString {
    
    public var toString: String {
        return self as String
    }
}

public extension String {
    
    public var toNSString: NSString {
        return self as NSString
    }
    /// длина строки через nsstring
    public var length: Int {
        return toNSString.length
    }
}

private let urlQueryAllowedSet = CharacterSet.urlQueryAllowed

public extension String {
    /// обычная строка в запросную строку
    public var urlQueryEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: urlQueryAllowedSet)
    }
    /// обычная строка в запросную строку
    public var urlQueryEncodedOrSelf: String {
        return addingPercentEncoding(withAllowedCharacters: urlQueryAllowedSet) ?? self
    }
    /// запросная строка в обычную
    public var urlQueryDecoded: String? {
        return removingPercentEncoding
    }
    /// запросная строка в обычную
    public var urlQueryDecodedOrSelf: String {
        return removingPercentEncoding ?? self
    }
}

private let regexTrimmingLeadingWhitespace = try? NSRegularExpression(pattern: "(?:^\\s+)", options: .caseInsensitive)
private let regexTrimmingTrailingWhitespace = try? NSRegularExpression(pattern: "(?:\\s+$)", options: .caseInsensitive)

public extension String {
    
    public func trimmingLeadingWhitespace() -> String {
        switch regexTrimmingLeadingWhitespace {
        case .some(let regex):
            let range = NSRange(location: 0, length: toNSString.length)
            return regex.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: "$1")
        default:
            return self
        }
    }
    
    public func trimmingTrailingWhitespace() -> String {
        switch regexTrimmingTrailingWhitespace {
        case .some(let regex):
            let range = NSRange(location: 0, length: toNSString.length)
            return regex.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: "$1")
        default:
            return self
        }
    }
}

// MARK: - Version

public extension String {
    /// Версия приложения
    public static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
