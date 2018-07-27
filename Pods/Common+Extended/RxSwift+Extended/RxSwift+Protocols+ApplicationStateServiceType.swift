import Common
import RxCocoa
import RxSwift
import UIKit

public protocol ApplicationStateServiceType {
    
    func observableApplicationActive() -> Observable<Bool>
}

private var _service: ApplicationStateServiceType?

public func getApplicationStateService() -> ApplicationStateServiceType {
    switch _service {
    case .some(let service):
        return service
    default:
        let service = Service()
        _service = service
        return service
    }
}

private final class Service: DisposeBagProvider {
    
    lazy var relay = BehaviorRelay<Bool>(value: false)
    
    init() {
        observableApplicationActiveInitial()
            .startWith(false)
            .distinctUntilChanged()
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    func observableApplicationActiveInitial() -> Observable<Bool> {
        return UIApplication.shared.delegate?.observableApplicationActive() ?? observableApplicationActiveRetry()
    }
}

private func observableApplicationActiveRetry() -> Observable<Bool> {
    return Observable
        .just((), scheduler: MainScheduler.instance)
        .delay(1, scheduler: MainScheduler.instance)
        .take(1)
        .flatMap({ _ -> Observable<Bool> in
            return UIApplication.shared.delegate?.observableApplicationActive() ?? observableApplicationActiveRetry()
        })
}

extension Service: ApplicationStateServiceType {
    
    func observableApplicationActive() -> Observable<Bool> {
        return relay
            .asObservable()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}
