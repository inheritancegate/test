import UIKit

public struct TXSafeAreaInsetsChange: Equatable {
    
    public let curve: UIViewAnimationCurve
    public let duration: TimeInterval
    public let safeAreaInsets: UIEdgeInsets
    public let safeKeyboardInsets: UIEdgeInsets
    
    public static func ==(lhs: TXSafeAreaInsetsChange, rhs: TXSafeAreaInsetsChange) -> Bool {
        return lhs.duration == rhs.duration && lhs.safeAreaInsets == rhs.safeAreaInsets && lhs.safeKeyboardInsets == rhs.safeKeyboardInsets
    }
}
