import Common
import RxSwift

public func getNetworkActivityRelay() -> ActivityRelay {
    return Service.shared.relay
}

private final class Service: DisposeBagProvider {
    
    lazy var relay: ActivityRelay = ActivityRelay()
    static let shared: Service = Service()
    
    private init() {
        relay
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
}
