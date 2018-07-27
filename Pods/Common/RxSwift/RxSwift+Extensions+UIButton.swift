import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIButton {
    
    public func isHighlighted() -> Observable<Bool> {
        let selector = #selector(setter: UIButton.isHighlighted)
        let value: ([Any]) -> Bool? = { $0.first(where: { $0 is Bool }) as? Bool }
        return base
            .observable(selector: selector, value: value)
            .filterNil()
            .startWith(base.isHighlighted)
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
}
