import Foundation

public extension Int {
    
    public var enumeration: [Int] {
        guard self > 0 else { return [] }
        return Array<Int>(0 ..< self)
    }
}

public extension Int {
    
    public var half: Int? {
        guard self > 0 else {
            return nil
        }
        return Int(Double(self - (self % 2)) / 2.0)
    }
}
