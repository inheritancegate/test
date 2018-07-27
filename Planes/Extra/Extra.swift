import UIKit

struct Border {
    
    let color: UIColor
    let width: CGFloat
}

struct Corners {
    
    let color: UIColor
    let radius: CGFloat
}

struct Icon {
    
    let contentMode: UIViewContentMode
    let image: UIImage?
    let size: CGSize?
    let url: URL?
    
    init(contentMode: UIViewContentMode = .center, image: UIImage?, size: CGSize? = nil) {
        self.contentMode = contentMode
        self.image = image
        self.size = size
        self.url = nil
    }
    
    init(contentMode: UIViewContentMode = .center, size: CGSize? = nil, url: URL?) {
        self.contentMode = contentMode
        self.image = nil
        self.size = size
        self.url = url
    }
}
