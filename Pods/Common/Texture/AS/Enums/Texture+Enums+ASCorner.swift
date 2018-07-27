import Foundation

/// Углы скругления
public enum ASCorner {
    
    case bottomLeft
    case bottomRight
    case topLeft
    case topRight
    
    func points(radius: CGFloat) -> [CGPoint] {
        let array = [CGPoint(x: 0, y: 0), CGPoint(x: radius, y: 0), CGPoint(x: radius, y: radius), CGPoint(x: 0, y: radius)]
        switch self {
        case .bottomLeft:
            return [array[1], array[2], array[3], array[0]]
        case .bottomRight:
            return [array[0], array[1], array[2], array[3]]
        case .topLeft:
            return [array[2], array[3], array[0], array[1]]
        case .topRight:
            return [array[3], array[0], array[1], array[2]]
        }
    }
    
    func path(radius: CGFloat) -> CGPath {
        let points = self.points(radius: radius)
        let path = CGMutablePath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addQuadCurve(to: points[3], control: points[2])
        path.addLine(to: points[0])
        return path
    }
}
