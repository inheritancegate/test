import Foundation
import MobileCoreServices

public extension NSExtensionContext {
    
    var provider: NSItemProvider? {
        return inputItems
            .flatMap({ $0 as? NSExtensionItem})
            .flatMap({ $0.attachments as? [NSItemProvider] })
            .flatMap({ $0 })
            .filter({ $0.valid })
            .first
    }
}

public extension NSItemProvider {
    
    var valid: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }
}

public extension NSItemProvider {
    
    func url(_ completion: @escaping (URL?) -> Void) {
        loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (value, error) in
            guard let url = value as? NSURL else {
                completion(nil)
                return
            }
            guard let string = url.absoluteString else {
                completion(nil)
                return
            }
            completion(URL(string: string))
        }
    }
}
