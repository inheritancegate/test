import Foundation

public struct Updates {
    
    public let row: RowUpdates
    public let section: SectionUpdates
    
    public init(row: RowUpdates, section: SectionUpdates) {
        self.row = row
        self.section = section
    }
    
    public static var empty: Updates {
        return Updates(row: RowUpdates.empty, section: SectionUpdates.empty)
    }
    
    public var isEmpty: Bool {
        return row.isEmpty && section.isEmpty
    }
    
    public var isNonEmpty: Bool {
        return row.isNonEmpty || section.isNonEmpty
    }
}
