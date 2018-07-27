import Foundation
/// Обертка для pthread_mutex_t
public final class Mutex {
    
    private var mutex = pthread_mutex_t()
    
    public init(recursive: Bool = false) {
        var attributes = pthread_mutexattr_t()
        guard pthread_mutexattr_init(&attributes) == 0 else {
            fatalError()
        }
        pthread_mutexattr_settype(&attributes, recursive ? PTHREAD_MUTEX_RECURSIVE : PTHREAD_MUTEX_NORMAL)
        guard pthread_mutex_init(&mutex, &attributes) == 0 else {
            fatalError()
        }
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    private func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    private func unlock() {
        pthread_mutex_unlock(&mutex)
    }
    
    public func sync<R>(block: () throws -> R) rethrows -> R {
        lock()
        defer {
            unlock()
        }
        return try block()
    }
}
