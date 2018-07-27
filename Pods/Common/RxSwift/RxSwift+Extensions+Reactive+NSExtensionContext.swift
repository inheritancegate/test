import Foundation
import MobileCoreServices
import RxCocoa
import RxSwift

public extension Reactive where Base == NSExtensionContext {
    
    func observableExtensionURL() -> Observable<URL?> {
        return Observable<URL?>
            .create({ [provider = base.provider] (observer) -> Disposable in
                switch provider {
                case .some(let provider):
                    provider.url({ (url) in
                        observer.onNext(url)
                        observer.onCompleted()
                    })
                default:
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
    }
}
