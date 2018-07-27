import Foundation

public final class Weak<T>: CustomStringConvertible, CustomDebugStringConvertible {
    
    private weak var _value: AnyObject?
    
    public init(_ value: AnyObject?) {
        if let unwrapped = value {
            precondition(unwrapped.self is T)
            _value = value
        }
    }
    
    public var value: T? {
        return _value as? T
    }
    
    public var description: String {
        switch self.value {
        case .some(let value):
            switch value as? CustomStringConvertible {
            case .some(let value):
                return value.description
            default:
                return "\(value)"
            }
        default:
            return "nil"
        }
    }
    
    public var debugDescription: String {
        switch self.value {
        case .some(let value):
            switch value as? CustomDebugStringConvertible {
            case .some(let value):
                return value.debugDescription
            default:
                return "\(value)"
            }
        default:
            return "nil"
        }
    }
}
