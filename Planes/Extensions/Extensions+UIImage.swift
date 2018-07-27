import Foundation
import UIKit

extension UIImage {
    
    static func with(background: UIColor, border: Border? = nil, foreground: UIColor, radius: CGFloat) -> UIImage? {
        assert(radius > 1)
        let size = CGSize(width: radius * 2, height: radius * 2)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        let rect = CGRect(origin: .zero, size: size)
        context?.setFillColor(background.cgColor)
        context?.fill(rect)
        
        func path(offset: CGFloat, radius: CGFloat) -> CGPath {
            let path = CGMutablePath()
            
            let points = [
                CGPoint(x: offset, y: offset + radius),
                CGPoint(x: offset, y: offset),
                CGPoint(x: offset + radius, y: offset),
                CGPoint(x: offset + radius * 2, y: offset),
                CGPoint(x: offset + radius * 2, y: offset + radius),
                CGPoint(x: offset + radius * 2, y: offset + radius * 2),
                CGPoint(x: offset + radius, y: offset + radius * 2),
                CGPoint(x: offset, y: offset + radius * 2),
            ]
            
            path.move(to: points[0])
            path.addQuadCurve(to: points[2], control: points[1])
            path.addQuadCurve(to: points[4], control: points[3])
            path.addQuadCurve(to: points[6], control: points[5])
            path.addQuadCurve(to: points[0], control: points[7])
            return path
        }
        
        switch border {
        case .some(let border):
            context?.addPath(path(offset: 0, radius: radius))
            context?.setFillColor(border.color.cgColor)
            context?.closePath()
            context?.fillPath()
            context?.addPath(path(offset: border.width, radius: radius - border.width))
            context?.setFillColor(foreground.cgColor)
            context?.closePath()
            context?.fillPath()
        case .none:
            context?.addPath(path(offset: 0, radius: radius))
            context?.setFillColor(foreground.cgColor)
            context?.closePath()
            context?.fillPath()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
