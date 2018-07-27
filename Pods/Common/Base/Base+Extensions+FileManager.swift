import Foundation

public extension FileManager {
    
    public static var cachesDirectory: NSString {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [NSString]
        assert(paths.count > 0, "Caches directory doesn't exist")
        return paths[0]
    }
    
    public static var documentsDirectory: NSString {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [NSString]
        assert(paths.count > 0, "Documents directory doesn't exist")
        return paths[0]
    }
}

