import Foundation

public func whileDebugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        print(items, separator: separator, terminator: terminator)
    #else
        //
    #endif
}

public func whileDebug<T>(debug: () -> (T), release: () -> (T)) -> T {
    #if DEBUG
        return debug()
    #else
        return release()
    #endif
}

public func getValue<T>(debug: () -> (T), release: () -> (T)) -> T {
    #if DEBUG
        return debug()
    #else
        return release()
    #endif
}

public func whileDebug(_ closure: () -> ()) {
    #if DEBUG
        return closure()
    #else
        //
    #endif
}

public func whileDebugPrecondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "message", file: StaticString = #file, line: UInt = #line) {
    whileDebug {
        Swift.precondition(condition, message, file: file, line: line)
    }
}
