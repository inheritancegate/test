import Foundation

public protocol KeyboardOwnerProvider: class {
    
    var keyboardOwner: KeyboardOwner? { get }
}
