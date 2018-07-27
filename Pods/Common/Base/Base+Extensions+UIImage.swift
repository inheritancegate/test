import CoreGraphics
import UIKit

public extension UIImage {
    
    public func with(scale: CGFloat = UIScreen.main.scale, tint: UIColor?) -> UIImage {
        guard let tint = tint else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        let rect = CGRect(origin: .zero, size: size)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.multiply)
        guard let mask = self.cgImage else {
            return self
        }
        context.clip(to: rect, mask: mask)
        tint.setFill()
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
    public func with(blurRadius radius: CGFloat) -> UIImage? {
        guard let filter1 = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        guard let image1 = CIImage(image: self) else {
            return nil
        }
        filter1.setValue(image1, forKey: kCIInputImageKey)
        filter1.setValue(radius, forKey: kCIInputRadiusKey)
        guard let filter2 = CIFilter(name: "CICrop") else {
            return nil
        }
        filter2.setValue(filter1.outputImage, forKey: kCIInputImageKey)
        let vector = CIVector(cgRect: image1.extent)
        filter2.setValue(vector, forKey: "inputRectangle")
        guard let image2 = filter2.outputImage else {
            return nil
        }
        let context = CIContext(options: nil)
        guard let image3 = context.createCGImage(image2, from: image2.extent) else {
            return nil
        }
        return UIImage(cgImage: image3)
    }
    
    public func with(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let contextImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        image = contextImage
        UIGraphicsEndImageContext()
        return image
    }
    
    public func with(overlay: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: size))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(overlay.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public static func with(color: UIColor, scale: CGFloat = UIScreen.main.scale, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public static func with(border: UIColor, fill: UIColor? = nil, radius: CGFloat, scale: CGFloat = UIScreen.main.scale, width: CGFloat) -> UIImage? {
        precondition(width < radius)
        let diameter = radius + radius
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        if let fill = fill {
            let offset = width / 2
            
            func getPath0(diameter: CGFloat, offset: CGFloat, radius: CGFloat) -> CGPath {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: radius, y: offset))
                path.addQuadCurve(to: CGPoint(x: diameter - offset, y: radius), control: CGPoint(x: diameter - offset, y: offset))
                path.addQuadCurve(to: CGPoint(x: radius, y: diameter - offset), control: CGPoint(x: diameter - offset, y: diameter - offset))
                path.addQuadCurve(to: CGPoint(x: offset, y: radius), control: CGPoint(x: offset, y: diameter - offset))
                path.addQuadCurve(to: CGPoint(x: radius, y: offset), control: CGPoint(x: offset, y: offset))
                return path
            }
            
            let path = getPath0(diameter: diameter, offset: offset, radius: radius)
            let context = UIGraphicsGetCurrentContext()
            context?.addPath(path)
            context?.setFillColor(fill.cgColor)
            context?.closePath()
            context?.fillPath()
        }
        
        func getPath1(diameter: CGFloat, radius: CGFloat, width: CGFloat) -> CGPath {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: radius, y: 0))
            path.addQuadCurve(to: CGPoint(x: diameter, y: radius), control: CGPoint(x: diameter, y: 0))
            path.addQuadCurve(to: CGPoint(x: radius, y: diameter), control: CGPoint(x: diameter, y: diameter))
            path.addQuadCurve(to: CGPoint(x: 0, y: radius), control: CGPoint(x: 0, y: diameter))
            path.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint.init(x: radius, y: width))
            path.addQuadCurve(to: CGPoint(x: width, y: radius), control: CGPoint(x: width, y: width))
            path.addQuadCurve(to: CGPoint(x: radius, y: diameter - width), control: CGPoint(x: width, y: diameter - width))
            path.addQuadCurve(to: CGPoint(x: diameter - width, y: radius), control: CGPoint(x: diameter - width, y: diameter - width))
            path.addQuadCurve(to: CGPoint.init(x: radius, y: width), control: CGPoint(x: diameter - width, y: width))
            return path
        }
        
        let path = getPath1(diameter: diameter, radius: radius, width: width)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path)
        context?.setFillColor(border.cgColor)
        context?.closePath()
        context?.fillPath()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func with(maxHeight: CGFloat, maxWidth: CGFloat) -> UIImage? {
        guard let image = self.cgImage else {
            return nil
        }
        var height = CGFloat(image.height)
        var width = CGFloat(image.width)
        guard height > 0 && width > 0 else {
            return nil
        }
        let maxHeight = round(maxHeight)
        let maxWidth = round(maxWidth)
        guard height > maxHeight || width > maxWidth else {
            return nil
        }
        let heightProportions = height / maxHeight
        let widthProportions = width / maxWidth
        height = heightProportions > widthProportions ? maxHeight : round(height / widthProportions)
        width = widthProportions > heightProportions ? maxWidth : round(width / heightProportions)
        let size = CGSize(width: width, height: height)
        let bitmapInfo = image.bitmapInfo.rawValue
        let bitsPerComponent = image.bitsPerComponent
        let bytesPerRow = image.bytesPerRow
        let space = image.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect.init(origin: .zero, size: size))
        guard let newImage = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: newImage)
    }
    
    public func with(radius: CGFloat, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius).addClip()
        draw(in: CGRect(origin: .zero, size: size))
        defer {
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func with(background: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        let rect = CGRect(origin: .zero, size: size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(background.cgColor)
            context.fill(rect)
        }
        draw(in: rect)
        defer {
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func with(contentMode: UIViewContentMode = .center, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        guard self.size.width > 0, self.size.height > 0 else {
            return nil
        }
        switch contentMode {
        case .scaleAspectFill:
            precondition(size.width > 0 && size.height > 0)
            let aspectRequired = size.width / size.height
            let aspectCurrent = self.size.width / self.size.height
            let asdf = aspectRequired > aspectCurrent
            UIGraphicsBeginImageContextWithOptions(size, true, scale)
            let width = asdf ? size.width : self.size.width * size.height / self.size.height
            let height = asdf ? self.size.height * size.width / self.size.width : size.height
            let x = asdf ? 0 : (size.width - width) / 2
            let y = asdf ? (size.height - height) / 2 : 0
            let origin = CGPoint(x: x, y: y)
            self.draw(in: CGRect(origin: origin, size: size))
            defer {
                UIGraphicsEndImageContext()
            }
            return UIGraphicsGetImageFromCurrentImageContext()
        case .center:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let x = (size.width - self.size.width) / 2
            let y = (size.height - self.size.height) / 2
            let origin = CGPoint(x: x, y: y)
            self.draw(in: CGRect(origin: origin, size: self.size))
            defer {
                UIGraphicsEndImageContext()
            }
            return UIGraphicsGetImageFromCurrentImageContext()
        default:
            fatalError()
        }
    }
    
    public func with(capInsets: UIEdgeInsets, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        precondition(size.height > capInsets.top + capInsets.bottom)
        precondition(size.width > capInsets.left + capInsets.right)
        
//        let leftBottomDrawOrigin = CGPoint(x: 0, y: size.height - capInsets.bottom)
//        let leftBottomWithOrigin = CGPoint(x: 0, y: capInsets.bottom - self.size.height)
//        let leftBottomSize = CGSize(width: capInsets.left, height: capInsets.bottom)
//        let leftBottomImage = with(origin: leftBottomWithOrigin, size: leftBottomSize, scale: scale)
//
//        let leftCenterDrawOrigin = CGPoint(x: 0, y: capInsets.top)
//        let leftCenterDrawSize = CGSize(width: capInsets.left, height: size.height - capInsets.top - capInsets.bottom)
//        let leftCenterWithOrigin = CGPoint(x: 0, y: -capInsets.top)
//        let leftCenterWithSize = CGSize(width: capInsets.left, height: self.size.height - capInsets.top - capInsets.bottom)
//        let leftCenterImage = with(origin: leftCenterWithOrigin, size: leftCenterWithSize, scale: scale)
//
//        let leftTopDrawOrigin = CGPoint(x: 0, y: 0)
//        let leftTopWithOrigin = CGPoint(x: 0, y: 0)
//        let leftTopSize = CGSize(width: capInsets.left, height: capInsets.top)
//        let leftTopImage = with(origin: leftTopWithOrigin, size: leftTopSize, scale: scale)
//
//        let middleBottomDrawOrigin = CGPoint(x: capInsets.left, y: size.height - capInsets.bottom)
//        let middleBottomDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: capInsets.bottom)
//        let middleBottomWithOrigin = CGPoint(x: -capInsets.left, y: capInsets.bottom - self.size.height)
//        let middleBottomWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: capInsets.bottom)
//        let middleBottomImage = with(origin: middleBottomWithOrigin, size: middleBottomWithSize, scale: scale)
//
//        let middleCenterDrawOrigin = CGPoint(x: capInsets.left, y: capInsets.top)
//        let middleCenterDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: size.height - capInsets.top - capInsets.bottom)
//        let middleCenterWithOrigin = CGPoint(x: -capInsets.left, y: -capInsets.top)
//        let middleCenterWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: self.size.height - capInsets.top - capInsets.bottom)
//        let middleCenterImage = with(origin: middleCenterWithOrigin, size: middleCenterWithSize, scale: scale)
//
//        let middleTopDrawOrigin = CGPoint(x: capInsets.left, y: 0)
//        let middleTopDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: capInsets.top)
//        let middleTopWithOrigin = CGPoint(x: -capInsets.left, y: 0)
//        let middleTopWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: capInsets.top)
//        let middleTopImage = with(origin: middleTopWithOrigin, size: middleTopWithSize, scale: scale)
//
//        let rightBottomDrawOrigin = CGPoint(x: size.width - capInsets.right, y: size.height - capInsets.bottom)
//        let rightBottomWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: capInsets.bottom - self.size.height)
//        let rightBottomSize = CGSize(width: capInsets.right, height: capInsets.bottom)
//        let rightBottomImage = with(origin: rightBottomWithOrigin, size: rightBottomSize, scale: scale)
//
//        let rightCenterDrawOrigin = CGPoint(x: size.width - capInsets.right, y: capInsets.top)
//        let rightCenterDrawSize = CGSize(width: capInsets.right, height: size.height - capInsets.top - capInsets.bottom)
//        let rightCenterWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: -capInsets.top)
//        let rightCenterWithSize = CGSize(width: capInsets.right, height: self.size.height - capInsets.top - capInsets.bottom)
//        let rightCenterImage = with(origin: rightCenterWithOrigin, size: rightCenterWithSize, scale: scale)
//
//        let rightTopDrawOrigin = CGPoint(x: size.width - capInsets.right, y: 0)
//        let rightTopWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: 0)
//        let rightTopSize = CGSize(width: capInsets.right, height: capInsets.top)
//        let rightTopImage = with(origin: rightTopWithOrigin, size: rightTopSize, scale: scale)
        
        let leftBottomDrawOrigin = CGPoint(x: 0, y: size.height - capInsets.bottom)
        let leftBottomWithOrigin = CGPoint(x: 0, y: capInsets.bottom - self.size.height)
        let leftBottomSize = CGSize(width: capInsets.left, height: capInsets.bottom)
        var leftBottomImage: UIImage?
        
        let leftCenterDrawOrigin = CGPoint(x: 0, y: capInsets.top)
        let leftCenterDrawSize = CGSize(width: capInsets.left, height: size.height - capInsets.top - capInsets.bottom)
        let leftCenterWithOrigin = CGPoint(x: 0, y: -capInsets.top)
        let leftCenterWithSize = CGSize(width: capInsets.left, height: self.size.height - capInsets.top - capInsets.bottom)
        var leftCenterImage: UIImage?
        
        let leftTopDrawOrigin = CGPoint(x: 0, y: 0)
        let leftTopWithOrigin = CGPoint(x: 0, y: 0)
        let leftTopSize = CGSize(width: capInsets.left, height: capInsets.top)
        var leftTopImage: UIImage?
        
        let middleBottomDrawOrigin = CGPoint(x: capInsets.left, y: size.height - capInsets.bottom)
        let middleBottomDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: capInsets.bottom)
        let middleBottomWithOrigin = CGPoint(x: -capInsets.left, y: capInsets.bottom - self.size.height)
        let middleBottomWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: capInsets.bottom)
        var middleBottomImage: UIImage?
        
        let middleCenterDrawOrigin = CGPoint(x: capInsets.left, y: capInsets.top)
        let middleCenterDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: size.height - capInsets.top - capInsets.bottom)
        let middleCenterWithOrigin = CGPoint(x: -capInsets.left, y: -capInsets.top)
        let middleCenterWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: self.size.height - capInsets.top - capInsets.bottom)
        var middleCenterImage: UIImage?
        
        let middleTopDrawOrigin = CGPoint(x: capInsets.left, y: 0)
        let middleTopDrawSize = CGSize(width: size.width - capInsets.left - capInsets.right, height: capInsets.top)
        let middleTopWithOrigin = CGPoint(x: -capInsets.left, y: 0)
        let middleTopWithSize = CGSize(width: self.size.width - capInsets.left - capInsets.right, height: capInsets.top)
        var middleTopImage: UIImage?
        
        let rightBottomDrawOrigin = CGPoint(x: size.width - capInsets.right, y: size.height - capInsets.bottom)
        let rightBottomWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: capInsets.bottom - self.size.height)
        let rightBottomSize = CGSize(width: capInsets.right, height: capInsets.bottom)
        var rightBottomImage: UIImage?
        
        let rightCenterDrawOrigin = CGPoint(x: size.width - capInsets.right, y: capInsets.top)
        let rightCenterDrawSize = CGSize(width: capInsets.right, height: size.height - capInsets.top - capInsets.bottom)
        let rightCenterWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: -capInsets.top)
        let rightCenterWithSize = CGSize(width: capInsets.right, height: self.size.height - capInsets.top - capInsets.bottom)
        var rightCenterImage: UIImage?
        
        let rightTopDrawOrigin = CGPoint(x: size.width - capInsets.right, y: 0)
        let rightTopWithOrigin = CGPoint(x: capInsets.right - self.size.width, y: 0)
        let rightTopSize = CGSize(width: capInsets.right, height: capInsets.top)
        var rightTopImage: UIImage?
        
        DispatchQueue.concurrentPerform(iterations: 9) { [weak image = self] (index) in
            switch index {
            case 0:
                leftBottomImage = with(origin: leftBottomWithOrigin, size: leftBottomSize, scale: scale)
            case 1:
                leftCenterImage = with(origin: leftCenterWithOrigin, size: leftCenterWithSize, scale: scale)
            case 2:
                leftTopImage = with(origin: leftTopWithOrigin, size: leftTopSize, scale: scale)
            case 3:
                middleBottomImage = with(origin: middleBottomWithOrigin, size: middleBottomWithSize, scale: scale)
            case 4:
                middleCenterImage = with(origin: middleCenterWithOrigin, size: middleCenterWithSize, scale: scale)
            case 5:
                middleTopImage = with(origin: middleTopWithOrigin, size: middleTopWithSize, scale: scale)
            case 6:
                rightBottomImage = with(origin: rightBottomWithOrigin, size: rightBottomSize, scale: scale)
            case 7:
                rightCenterImage = with(origin: rightCenterWithOrigin, size: rightCenterWithSize, scale: scale)
            case 8:
                rightTopImage = with(origin: rightTopWithOrigin, size: rightTopSize, scale: scale)
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        leftBottomImage?.draw(in: CGRect(origin: leftBottomDrawOrigin, size: leftBottomSize).integral)
        leftCenterImage?.draw(in: CGRect(origin: leftCenterDrawOrigin, size: leftCenterDrawSize).integral)
        leftTopImage?.draw(in: CGRect(origin: leftTopDrawOrigin, size: leftTopSize).integral)
        middleBottomImage?.draw(in: CGRect(origin: middleBottomDrawOrigin, size: middleBottomDrawSize).integral)
        middleCenterImage?.draw(in: CGRect(origin: middleCenterDrawOrigin, size: middleCenterDrawSize).integral)
        middleTopImage?.draw(in: CGRect(origin: middleTopDrawOrigin, size: middleTopDrawSize).integral)
        rightBottomImage?.draw(in: CGRect(origin: rightBottomDrawOrigin, size: rightBottomSize).integral)
        rightCenterImage?.draw(in: CGRect(origin: rightCenterDrawOrigin, size: rightCenterDrawSize).integral)
        rightTopImage?.draw(in: CGRect(origin: rightTopDrawOrigin, size: rightTopSize).integral)

        defer {
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    private func with(origin: CGPoint, size: CGSize, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: origin, size: self.size))
        defer {
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func add(color: UIColor) -> UIImage? {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        defer {
            UIGraphicsEndImageContext()
        }
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(x: 9, y: 0, width: 2, height: 2))
        context?.fillEllipse(in: CGRect(x: 9, y: 16, width: 2, height: 2))
        context?.fillEllipse(in: CGRect(x: 1, y: 8, width: 2, height: 2))
        context?.fillEllipse(in: CGRect(x: 17, y: 8, width: 2, height: 2))
        context?.clear(CGRect(x: 9, y: 1, width: 2, height: 16))
        context?.clear(CGRect(x: 2, y: 8, width: 16, height: 2))
        context?.fill(CGRect(x: 9, y: 1, width: 2, height: 16))
        context?.clear(CGRect(x: 2, y: 8, width: 16, height: 2))
        context?.fill(CGRect(x: 2, y: 8, width: 16, height: 2))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func arrow(back: UIColor? = nil, fill: UIColor, line: CGFloat, right: Bool, width: CGFloat) -> UIImage? {
        let l = line
        let w = width
        let a = l * (1 - 1 / sqrt(2))
        let d = l / sqrt(2)
        let p = w - a - d
        let x = w - a - l * sqrt(2)
        precondition(x > 0)
        let point0 = right ? CGPoint(x: w, y: a + p) : CGPoint(x: 0, y: a + p)
        let point1 = right ? point0.move(x: -p, y: p) : point0.move(x: p, y: p)
        let point2 = right ? point1.move(x: -d - a, y: a) : point1.move(x: d + a, y: a)
        let point3 = right ? point2.move(x: a, y: -a - d) : point2.move(x: -a, y: -a - d)
        let point4 = right ? point3.move(x: x, y: -x) : point3.move(x: -x, y: -x)
        let point5 = right ? point4.move(x: -x, y: -x) : point4.move(x: x, y: -x)
        let point6 = right ? point5.move(x: -a, y: -a - d) : point5.move(x: a, y: -a - d)
        let point7 = right ? point6.move(x: a + d, y: a) : point6.move(x: -a - d, y: a)
        let size = CGSize(width: width, height: a + p + a + p)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        var path = CGMutablePath()
        path.move(to: point0)
        path.addLine(to: point1)
        path.addQuadCurve(to: point3, control: point2)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addQuadCurve(to: point7, control: point6)
        
        let context = UIGraphicsGetCurrentContext()
        if let color = back?.cgColor {
            let rect = CGRect(origin: .zero, size: size)
            context?.setFillColor(color)
            context?.fill(rect)
        }
        context?.addPath(path)
        context?.setFillColor(fill.cgColor)
        context?.closePath()
        context?.fillPath()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func more(color: UIColor) -> UIImage? {
        let size = CGSize(width: 18.5, height: 4.5)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        defer {
            UIGraphicsEndImageContext()
        }
        context?.setFillColor(color.cgColor)
        for x in [0, 1, 2] {
            let offset: CGFloat = 7 * CGFloat(x)
            context?.fillEllipse(in: CGRect(x: offset, y: 0, width: 4.5, height: 4.5))
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension CGPoint {
    
    func move(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}
