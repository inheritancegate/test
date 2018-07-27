import Foundation

public protocol FutureProvider: class {
    
    var future: Future { get }
}

private var FUTURE_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension FutureProvider {
    
    public var future: Future {
        if let value = objc_getAssociatedObject(self, &FUTURE_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY) as? Future {
            return value
        } else {
            let value = Future()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &FUTURE_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY, value, policy)
            return value
        }
    }
}
