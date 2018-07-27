import Foundation

public extension KeyedDecodingContainer {
    
    public func decode<T>(key: K) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }
}
