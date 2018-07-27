import RxCocoa
import RxOptional
import RxSwift

public extension Reactive where Base == NotificationCenter {
    
    public func observe<T:NotificationRepresentable>(with type: T.Type) -> Observable<T> {
        let observables: [Observable<Notification>] = T.notificationRepresentableNames()
            .map({ [unowned base] (name) -> Observable<Notification> in
                return base.rx.notification(name)
            })
        return Observable
            .from(observables)
            .merge()
            .map({ notification -> T? in
                let mappedValue: T? = T.notificationRepresentableMapping(notification)
                return mappedValue
            })
            .filterNil()
            .share(replay: 1, scope: .whileConnected)
    }
}
