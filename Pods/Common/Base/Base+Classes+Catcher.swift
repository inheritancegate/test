import Foundation

public func proceed<T>(_ block: () throws -> T) throws -> T {
    var value: T?
    var error: Error!
    Catcher.try({
        do {
            value = try block()
        } catch let _error {
            error = _error
        }
    }, catch: { (exception: NSException) in
        let description = "\(exception)"
        whileDebug {
            fatalError(description)
        }
        error = NSError(domain: "NSException", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    })
    switch value {
    case .some(let value):
        return value
    case .none:
        throw error
    }
}
