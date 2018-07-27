import UIKit

public protocol UserInteractionServiceType: class {
    /// Возвращает ключ, по которому можно досрочно закончить игнорирование жестов
    @discardableResult
    func ignoringBegin(duration: TimeInterval, file: String, line: Int, logs: Bool) -> String
    /// Возвращает true если по данному ключу еще не было прекращения игнорирования
    @discardableResult
    func ignoringComplete(key: String, logs: Bool) -> Bool
}

public extension UserInteractionServiceType {
    /// Возвращает ключ, по которому можно досрочно закончить игнорирование жестов
    @discardableResult
    func ignoringBegin(_ duration: TimeInterval, file: String = #file, line: Int = #line, logs: Bool = false) -> String {
        return ignoringBegin(duration: duration, file: file, line: line, logs: logs)
    }
    /// Возвращает true если по данному ключу еще не было прекращения игнорирования
    @discardableResult
    func ignoringComplete(key: String, logs: Bool = false) -> Bool {
        return ignoringComplete(key: key, logs: logs)
    }
}
/// Сервис контролирования пользовательских жестов с замыканиями, которые задает сам разработчик
public func getUserInteractionService(ignoringBegin: @escaping () -> (), ignoringComplete: @escaping () -> (), ignoringTimeout: @escaping (String, Int) -> ()) -> UserInteractionServiceType {
    return Service(ignoringBegin: ignoringBegin, ignoringComplete: ignoringComplete, ignoringTimeout: ignoringTimeout)
}

private final class Service: UserInteractionServiceType {
    
    lazy var keys = Set<String>()
    let mutex = Mutex()
    let ignoringBeginClosure: () -> ()
    let ignoringCompleteClosure: () -> ()
    let ignoringTimeoutClosure: (String, Int) -> ()
    
    init(ignoringBegin: @escaping () -> (), ignoringComplete: @escaping () -> (), ignoringTimeout: @escaping (String, Int) -> ()) {
        self.ignoringBeginClosure = ignoringBegin
        self.ignoringCompleteClosure = ignoringComplete
        self.ignoringTimeoutClosure = ignoringTimeout
    }
    /// Возвращает ключ, по которому можно досрочно закончить игнорирование жестов
    @discardableResult
    func ignoringBegin(duration: TimeInterval, file: String, line: Int, logs: Bool) -> String {
        ignoringBeginClosure()
        var key = UUID().uuidString
        mutex.sync {
            while keys.contains(key) {
                key = UUID().uuidString
            }
            keys.insert(key)
            if logs {
                whileDebugPrint("Ignoring Count", keys.count)
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + duration) { [weak service = self, file, key, line, logs] in
            let complete = service?.ignoringComplete(key: key, logs: logs) ?? false
            if complete == true {
                service?.ignoringTimeoutClosure(file, line)
            }
        }
        return key
    }
    /// Возвращает true если по данному ключу еще не было прекращения игнорирования
    @discardableResult
    func ignoringComplete(key: String, logs: Bool) -> Bool {
        let contained = mutex.sync { () -> Bool in
            let contains = keys.contains(key)
            keys.remove(key)
            if logs {
                whileDebugPrint("Ignoring Count", keys.count)
            }
            return contains
        }
        if contained {
            ignoringCompleteClosure()
        }
        return contained
    }
    
    deinit {
        mutex.sync {
            for _ in keys {
                ignoringCompleteClosure()
            }
        }
    }
}
