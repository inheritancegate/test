import Foundation

public extension CodingKey {

    public static func container(decoder: Decoder) throws -> KeyedDecodingContainer<Self> {
        return try decoder.container(keyedBy: Self.self)
    }

    public static func container(encoder: Encoder) -> KeyedEncodingContainer<Self> {
        return encoder.container(keyedBy: Self.self)
    }
}
