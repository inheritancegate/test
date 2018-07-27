import Foundation

public protocol TXViewControllerInsetsDelegate: class {
    
    func controllerInsetsDidChange(_ controller: TXViewController, curve: UIViewAnimationCurve, duration: TimeInterval, safeAreaInsets: UIEdgeInsets, safeKeyboardInsets: UIEdgeInsets)
}
