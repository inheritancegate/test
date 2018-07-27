import RxCocoa
import RxSwift
import UIKit

public extension UIView {
    
    public func observableLayoutSubviews(when: InvocationTime = InvocationTime.afterMessageIsInvoked) -> Observable<UIView?> {
        let selector = #selector(UIView.layoutSubviews)
        let value: ([Any]) -> UIView? = { [weak view = self] _ in view }
        return observable(selector: selector, value: value, when: when)
    }
}
