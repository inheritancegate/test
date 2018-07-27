import Foundation

public extension CGPoint {
    
    public func updated(with block: (CGPoint) -> CGPoint) -> CGPoint {
        return block(self)
    }
}
