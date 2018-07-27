import AsyncDisplayKit
/// Углы скругления
public struct Corners: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let none = Corners(rawValue: 1 << 0)
    public static let bottomLeft = Corners(rawValue: 1 << 1)
    public static let bottomRight = Corners(rawValue: 1 << 2)
    public static let topLeft = Corners(rawValue: 1 << 3)
    public static let topRight = Corners(rawValue: 1 << 4)
    
    public static let all: Corners = [.bottomLeft, .bottomRight, .topLeft, .topRight]
    public static let bottom: Corners = [.bottomLeft, .bottomRight]
    public static let left: Corners = [.bottomLeft, .topLeft]
    public static let right: Corners = [.bottomRight, .topRight]
    public static let top: Corners = [.topLeft, .topRight]
    
    private func points(radius: CGFloat) -> [CGPoint]? {
        let array = [CGPoint(x: 0, y: 0), CGPoint(x: radius, y: 0), CGPoint(x: radius, y: radius), CGPoint(x: 0, y: radius)]
        if contains(.bottomLeft) {
            return [array[1], array[2], array[3], array[0]]
        } else if contains(.bottomRight) {
            return [array[0], array[1], array[2], array[3]]
        } else if contains(.topLeft) {
            return [array[2], array[3], array[0], array[1]]
        } else if contains(.topRight) {
            return [array[3], array[0], array[1], array[2]]
        } else {
            return nil
        }
    }
    
    func path(radius: CGFloat) -> CGPath? {
        if let points = self.points(radius: radius) {
            let path = CGMutablePath()
            path.move(to: points[0])
            path.addLine(to: points[1])
            path.addQuadCurve(to: points[3], control: points[2])
            path.addLine(to: points[0])
            return path
        }
        return nil
    }
}
