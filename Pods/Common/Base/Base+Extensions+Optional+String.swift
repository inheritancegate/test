import Foundation

public extension Optional where Wrapped == String {
    
    public var isEmpty: Bool {
        if case .some(let string) = self {
            return string.isEmpty
        } else {
            return true
        }
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension Optional where Wrapped: Hashable {
    
    public func hashValue(default value: Int) -> Int {
        switch self {
        case .some(let wrapped):
            return wrapped.hashValue
        case .none:
            return value
        }
    }
}
