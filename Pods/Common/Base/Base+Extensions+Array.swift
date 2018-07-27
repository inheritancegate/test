import Foundation

public extension Array {
    
    public func object(at index: Int) -> Element? {
        return count > index ? self[index] : nil
    }
}

public extension Array {
    
    public func appending(_ object: Element) -> Array {
        var array = self
        array.append(object)
        return array
    }
    
    public func replacing(at index: Int, with factory: (Element) -> Element) -> Array {
        guard let object = object(at: index) else {
            return self
        }
        var array = self
        array.remove(at: index)
        array.insert(factory(object), at: index)
        return array
    }
    
    public func sendFirstOccurrenceToStart(where predicate: (Element) -> Bool) -> Array {
        if let index = self.index(where: { predicate($0) }), index > 0 {
            var array = self
            let object = array.remove(at: index)
            array.insert(object, at: 0)
            return array
        }
        return self
    }
}

public extension Sequence where Element == String {
    
    public func sorted(_ comparisonResult: ComparisonResult) -> [String] {
        return self.sorted(by: { $0.compare($1) == comparisonResult })
    }
}
