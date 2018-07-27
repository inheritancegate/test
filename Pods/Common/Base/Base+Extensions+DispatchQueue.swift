import Foundation

private var array = [String]()
private var mutex = Mutex()

public extension DispatchQueue {
    
    public static func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = "\(file)+\(function)+\(line)"
        once(token: token, block: block)
    }
    
    private class func once(token: String, block: () -> Void) {
        mutex.sync {
            switch array.contains(token) {
            case false:
                array.append(token)
                block()
            default:
                break
            }
        }
    }
}
