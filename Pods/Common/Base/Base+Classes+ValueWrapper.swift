import Foundation

public final class ValueWrapper<T>: NSObject {
    
    public let value: T
    
    public init(value: T) {
        self.value = value
    }
}
