import Foundation

public extension Double {
    
    public var tailingZero: String {
        return String(format: "%g", self)
    }
}

public extension TimeInterval {
    
    public var toInt: Int {
        return Int(self)
    }
}
