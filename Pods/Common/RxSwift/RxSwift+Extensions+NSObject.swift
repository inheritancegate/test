import RxCocoa
import RxSwift

public extension NSObject {
    
    public func observable<T>(selector: Selector, value: @escaping ([Any]) -> T, when: InvocationTime = .afterMessageIsInvoked) -> Observable<T> {
        let observable: Observable<[Any]> = {
            switch when {
            case .afterMessageIsInvoked:
                return rx.methodInvoked(selector)
            case .beforeMessageIsInvoked:
                return rx.sentMessage(selector)
            }
        }()
        return observable
            .map({ value($0) })
            .share(replay: 1, scope: .whileConnected)
    }
}
