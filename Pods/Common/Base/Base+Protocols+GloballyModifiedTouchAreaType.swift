import Foundation

public protocol GloballyModifiedTouchAreaType: class {
    
    var modifiedBounds: CGRect { get }
    var modifiedBoundsPriority: Int { get }
    var modifiedHitTestView: UIView { get }
}
