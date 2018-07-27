import Foundation

public struct SectionUpdates {
    
    public let delete: IndexSet
    public let insert: IndexSet
    public let reload: IndexSet
    
    public init(delete: IndexSet, insert: IndexSet, reload: IndexSet) {
        self.delete = delete
        self.insert = insert
        self.reload = reload
    }
    
    public static var empty: SectionUpdates {
        return SectionUpdates(delete: IndexSet(), insert: IndexSet(), reload: IndexSet())
    }
    
    public var isEmpty: Bool {
        return delete.count == 0 && insert.count == 0 && reload.count == 0
    }
    
    public var isNonEmpty: Bool {
        return delete.count > 0 || insert.count > 0 || reload.count > 0
    }
}
