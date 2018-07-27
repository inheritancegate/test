import Foundation

public protocol MutexProvider: class {
    
    func mutex(key: AnyHashable) -> Mutex
}

private var MUTEX_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension MutexProvider {
    
    func mutex(key: AnyHashable) -> Mutex {
        let holder = self.holder
        return holder.mutex.sync { () -> Mutex in
            switch holder.cache[key] {
            case .some(let value):
                return value
            default:
                let value = Mutex()
                holder.cache[key] = value
                return value
            }
        }
    }

    private var holder: Holder {
        if let holder = objc_getAssociatedObject(self, &MUTEX_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY) as? Holder {
            return holder
        } else {
            let holder = Holder()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &MUTEX_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY, holder, policy)
            return holder
        }
    }
}

private final class Holder {
    
    let cache = ProtectedSynchronousCache<Mutex>()
    let mutex = Mutex()
}
