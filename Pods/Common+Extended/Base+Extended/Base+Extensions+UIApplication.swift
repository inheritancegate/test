import Foundation
import UIKit

public extension UIApplication {
    
    func proceed(url: URL, options: [String : Any] = [:], completionHandler: ((Bool) -> Swift.Void)? = nil) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: options, completionHandler: completionHandler)
        } else {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                let opened = self?.openURL(url) ?? false
                DispatchQueue.main.async {
                    completionHandler?(opened)
                }
            }
        }
    }
}
