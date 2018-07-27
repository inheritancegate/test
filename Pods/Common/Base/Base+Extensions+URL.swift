import Foundation

public extension URL {
    
    public var queryitems: [String: String] {
        guard let queryitems = URLComponents(string: absoluteString)?.queryItems else {
            return [:]
        }
        return queryitems
            .reduce(into: [String:String]()) { (dictionary, item) in
                dictionary[item.name] = item.value
        }
    }
}
