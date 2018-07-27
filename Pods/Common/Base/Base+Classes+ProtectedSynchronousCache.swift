import Foundation
@available(*, deprecated, message: "Следует перестать использовать везде")
public class DictionarySynchronous1D<K0, V> where K0: Hashable {
    
    private lazy var dictionary = [K0: V]()
    private lazy var mutex = Mutex()
    private let synchronous: Bool
    
    public init(synchronous: Bool = true) {
        self.synchronous = synchronous
    }
    
    public subscript (key0: K0) -> V? {
        get {
            let block: () -> V? = { [weak self] in
                return self?.dictionary[key0]
            }
            return synchronous ? mutex.sync(block: block) : block()
        }
        set {
            let block: () -> Void = { [weak self] in
                self?.dictionary[key0] = newValue
            }
            synchronous ? mutex.sync(block: block) : block()
        }
    }
}
@available(*, deprecated, message: "Следует перестать использовать везде")
public class DictionarySynchronous2D<K1, K0, V> where K0: Hashable, K1: Hashable {
    
    private lazy var dictionary = [K1: [K0: V]]()
    private lazy var mutex = Mutex()
    private let synchronous: Bool
    
    public init(synchronous: Bool = true) {
        self.synchronous = synchronous
    }
    
    public subscript (key1: K1, key0: K0) -> V? {
        get {
            let block: () -> V? = { [weak self] in
                if self?.dictionary[key1] == nil {
                    self?.dictionary[key1] = [K0: V]()
                }
                return self?.dictionary[key1]?[key0]
            }
            return synchronous ? mutex.sync(block: block) : block()
        }
        set {
            let block: () -> Void = { [weak self] in
                if self?.dictionary[key1] == nil {
                    self?.dictionary[key1] = [K0: V]()
                }
                self?.dictionary[key1]?[key0] = newValue
            }
            synchronous ? mutex.sync(block: block) : block()
        }
    }
}
@available(*, deprecated, message: "Следует перестать использовать везде")
public class ProtectedSynchronousCache<T> {
    
    private lazy var dictionary = [Int: [Int: T]]()
    private lazy var mutex = Mutex()
    
    public init() {
        //
    }
    
    public subscript (depth0: AnyHashable) -> T? {
        get {
            return mutex.sync { () -> T? in
                if dictionary[0] == nil {
                    dictionary[0] = [Int: T]()
                }
                return dictionary[0]?[depth0.hashValue]
            }
        }
        set {
            mutex.sync { () in
                if dictionary[0] == nil {
                    dictionary[0] = [Int: T]()
                }
                dictionary[0]?[depth0.hashValue] = newValue
            }
        }
    }
    
    public subscript (depth1: AnyHashable, depth0: AnyHashable) -> T? {
        get {
            return mutex.sync { () -> T? in
                if dictionary[depth1.hashValue] == nil {
                    dictionary[depth1.hashValue] = [Int: T]()
                }
                return dictionary[depth1.hashValue]?[depth0.hashValue]
            }
        }
        set {
            mutex.sync { () in
                if dictionary[depth1.hashValue] == nil {
                    dictionary[depth1.hashValue] = [Int: T]()
                }
                dictionary[depth1.hashValue]?[depth0.hashValue] = newValue
            }
        }
    }
}
