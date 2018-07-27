import Common
import RxCocoa
import RxSwift

public extension UIApplicationDelegate {
    
    public func observableApplicationActive(when: InvocationTime = InvocationTime.afterMessageIsInvoked) -> Observable<Bool> {
        weak var object = self as? NSObject
        let array: [(Selector, ([Any]) -> Bool)] = [
            (#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), { _ in true}),
            (#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), { _ in false}),
            (#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), { _ in false}),
            (#selector(UIApplicationDelegate.applicationWillResignActive(_:)), { _ in false})
        ]
        let active: Bool = {
            switch UIApplication.shared.applicationState {
            case .active:
                return true
            case .background, .inactive:
                return false
            }
        }()
        return Observable
            .from(array.flatMap({ selector, value in object?.observable(selector: selector, value: value, when: when) }))
            .merge()
            .startWith(active)
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }
}
