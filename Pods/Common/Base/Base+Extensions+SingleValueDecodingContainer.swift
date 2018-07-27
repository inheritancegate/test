import Foundation

public extension SingleValueDecodingContainer {
    
    public mutating func decode<T>() throws -> T where T: Decodable {
        return try decode(T.self)
    }
}
