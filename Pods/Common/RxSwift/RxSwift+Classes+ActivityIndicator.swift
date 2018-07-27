import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

public class ActivityRelay : SharedSequenceConvertibleType {
    
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _loading: SharedSequence<SharingStrategy, Bool>
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    
    public init() {
        _loading = _relay
            .asDriver()
            .map({ $0 > 0 })
            .distinctUntilChanged()
    }
    
    public func trackActivity<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }, observableFactory: { (token: ActivityToken<O.E>) -> Observable<O.E> in
            return token.asObservable()
        })
    }
    
    public var isActive: Bool {
        _lock.lock()
        let active = _relay.value > 0
        _lock.unlock()
        return active
    }
    
    private func increment() {
        _lock.lock()
        let value = _relay.value + 1
        _relay.accept(value)
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        let value = _relay.value - 1
        _relay.accept(value)
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }
}
