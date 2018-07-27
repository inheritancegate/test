import Foundation

public extension NSCoder {
    
    public func encode<T>(_ object: T?, key: String) {
        if let object = object {
            self.encode(object, forKey: key)
        }
    }
    
    private func _decode<T>(key: String) throws -> T {
        guard containsValue(forKey: key) else {
            throw NSError(domain: "Decoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Значение отсутствует для ключа: " + key])
        }
        if let object = decodeObject(forKey: key) as? T {
            return object
        }
        switch T.self {
        case is Bool.Type:
            if let object = decodeBool(forKey: key) as? T {
                return object
            }
        case is Double.Type:
            if let object = decodeDouble(forKey: key) as? T {
                return object
            }
        case is Float.Type:
            if let object = decodeFloat(forKey: key) as? T {
                return object
            }
        case is Int.Type:
            if let object = decodeInteger(forKey: key) as? T {
                return object
            }
        case is Int32.Type:
            if let object = decodeInt32(forKey: key) as? T {
                return object
            }
        case is Int64.Type:
            if let object = decodeInt64(forKey: key) as? T {
                return object
            }
        default:
            break
        }
        let description = "key: " + key + ", type: " + String(describing: T.self)
        whileDebug {
            fatalError(description)
        }
        throw NSError(domain: "Decoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать значение к типу \(description)"])
    }
    
    public func decode<T>(key: String) throws -> T {
        return try proceed { () -> T in
            return try _decode(key: key)
        }
    }
}
