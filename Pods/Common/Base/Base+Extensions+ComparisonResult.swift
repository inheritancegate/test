import Foundation

public extension ComparisonResult {
    
    public var ascending: Bool {
        switch self {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    public var descending: Bool {
        switch self {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }
    
    public var same: Bool {
        switch self {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
