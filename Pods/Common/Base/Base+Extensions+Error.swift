import Foundation

public extension Swift.Error {
    
    public static func temp<T>(_ convert: (NSError) -> T, file: String = #file, line: Int = #line) -> T where T: Swift.Error {
        let error = NSError(domain: "Temporary Error", code: 0, userInfo: ["file": file, "line": line])
        return convert(error)
    }
}
