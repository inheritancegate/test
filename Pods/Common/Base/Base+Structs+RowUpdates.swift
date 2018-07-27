import Foundation

public struct RowUpdates {
    
    public let delete: [IndexPath]
    public let insert: [IndexPath]
    public let reload: [IndexPath]
    public let move: [(IndexPath, IndexPath)]
    
    public static var empty: RowUpdates {
        return RowUpdates(delete: [], insert: [], reload: [], move: [])
    }
    
    public var isEmpty: Bool {
        return delete.count == 0 && insert.count == 0 && reload.count == 0 && move.count == 0
    }
    
    public var isNonEmpty: Bool {
        return delete.count > 0 || insert.count > 0 || reload.count > 0 || move.count > 0
    }
}
