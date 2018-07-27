import Foundation

open class SwiftCache<K, V> where K: AnyObject, V: AnyObject {
    /// Ссылка на оборачиваемый NSCache
    private let cache = NSCache<K, V>()
    ///
    public init(limit: Int? = nil) {
        if let limit = limit {
            self.limit = limit
        }
    }
    /// максимально число объектов (но это не точно)
    public var limit: Int {
        get {
            return cache.countLimit
        }
        set(countLimit) {
            cache.countLimit = countLimit
        }
    }
    ///
    public subscript (key: K) -> V? {
        get {
            return cache.object(forKey: key)
        }
        set(object) {
            switch object {
            case .some(let object):
                cache.setObject(object, forKey: key)
            case .none:
                cache.removeObject(forKey: key)
            }
        }
    }
    /// Сбросить кэш
    public func drop() {
        cache.removeAllObjects()
    }
}
