import Foundation
import WebKit

@available(iOS 9.0, *)
public extension WKWebView {

    public func clean(completion: CompletionOptional = nil) {
        DispatchQueue.main.async {
            let types = Set<String>([WKWebsiteDataTypeDiskCache,  WKWebsiteDataTypeOfflineWebApplicationCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeIndexedDBDatabases, WKWebsiteDataTypeWebSQLDatabases])
            let date = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: date) {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
}

