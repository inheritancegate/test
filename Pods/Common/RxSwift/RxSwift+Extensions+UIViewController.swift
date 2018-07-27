import RxCocoa
import RxSwift
import UIKit

public extension UIViewController {

    func observableViewState(states: [ViewState] = [.didAppear, .didDisappear, .willAppear, .willDisappear], when: InvocationTime = InvocationTime.afterMessageIsInvoked) -> Observable<ViewState> {
        let array: [(selector: Selector, value: ([Any]) -> ViewState)] = [
            (#selector(UIViewController.viewDidAppear(_:)), { _ in .didAppear}),
            (#selector(UIViewController.viewDidDisappear(_:)), { _ in .didDisappear}),
            (#selector(UIViewController.viewWillAppear(_:)), { _ in .willAppear}),
            (#selector(UIViewController.viewWillDisappear(_:)), { _ in .willDisappear})
        ].filter({ states.contains($0.value([])) })
        return Observable
            .from(array.flatMap({ [weak self] selector, value in self?.observable(selector: selector, value: value, when: when) }))
            .merge()
            .share(replay: 1, scope: .whileConnected)
    }
}
