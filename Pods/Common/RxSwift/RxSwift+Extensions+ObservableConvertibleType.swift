import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

public extension ObservableConvertibleType {
    
    public func trackActivity(_ activityRelay: ActivityRelay) -> Observable<E> {
        return activityRelay.trackActivity(self)
    }
}
