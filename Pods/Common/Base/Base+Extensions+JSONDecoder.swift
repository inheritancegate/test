import Foundation

public extension JSONDecoder {
    
    public func decode<T>(data: Data) throws -> T where T: Decodable {
        return try decode(T.self, from: data)
    }
}
