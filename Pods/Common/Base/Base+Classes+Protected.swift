import Foundation
///
open class Protected<T> {
    
    public var value: T {
        get {
            return _mutex.sync(block: { () -> T in
                return _value
            })
        }
        set {
            _mutex.sync { () in
                _value = newValue
            }
            _didSet?(newValue)
        }
    }
    
    public func change(_ block: (T) -> T) {
        var _temp: T!
        _mutex.sync {
            _value = block(_value)
            _temp = _value
        }
        _didSet?(_temp)
    }
    
    private var _didSet: ((T) -> Void)? = nil
    private var _mutex = Mutex()
    private var _value: T
    
    public init(_ value: T, didSet: ((T) -> Void)? = nil) {
        _didSet = didSet
        _value = value
    }
}
