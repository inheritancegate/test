import RxCocoa
import RxOptional
import RxSwift

public extension Observable {
    
    public func whileDebugPreconditionThreadIsMain(file: StaticString = #file, line: UInt = #line) -> Observable<Element> {
        return whileDebug(debug: { () -> Observable<Element> in
            return self
                .do(onNext: { (element: Element) in
                    Swift.precondition(Thread.isMainThread, "Это не главный поток!", file: file, line: line)
                })
        }, release: { () -> Observable<Element> in
            return self
        })
    }
    
    public func whileDebugPreconditionThreadIsNotMain(file: StaticString = #file, line: UInt = #line) -> Observable<Element> {
        return whileDebug(debug: { () -> Observable<Element> in
            return self
                .do(onNext: { (element: Element) in
                    Swift.precondition(Thread.isMainThread == false, "Это главный поток!", file: file, line: line)
                })
        }, release: { () -> Observable<Element> in
            return self
        })
    }
}

public extension Observable {
    
    func takeOnlyNext() -> Observable {
        return materialize()
            .flatMapLatest({ (event) -> Observable in
                switch event {
                case .next(let element):
                    return Observable.create({ (observer) -> Disposable in
                        defer {
                            observer.onNext(element)
                        }
                        return Disposables.create()
                    })
                default:
                    return Observable.never()
                }
            })
            .share(replay: 1, scope: .whileConnected)
    }
    
    func takeOnlyError() -> Observable<Error> {
        return materialize()
            .flatMapLatest({ (event) -> Observable<Error> in
                switch event {
                case .error(let error):
                    return Observable<Error>.create({ (observer) -> Disposable in
                        defer {
                            observer.onNext(error)
                        }
                        return Disposables.create()
                    })
                default:
                    return Observable<Error>.never()
                }
            })
            .share(replay: 1, scope: .whileConnected)
    }
}

public extension Observable {
    
    public func map<T>(to value: T) -> Observable<T> {
        return map({ _ in value })
    }
}

public extension Observable {
    /// cancel should be of the same type as factory because it returns an error
    @available(*, deprecated, message: "Works only with first element and then disposes. User \"flatMapLatest(observableCancel:observableFactory:)\" instead")
    public func flatMapLatest<T>(cancel: Observable<T>, factory: @escaping (E) throws -> Observable<T>) -> Observable<T> {
        let observableNormal = self
            .flatMap({ try factory($0) })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        return Observable<Observable<T>>
            .of(cancel, observableNormal)
            .merge()
            .take(1)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    /// cancel should be of the same type as factory because it returns an error
    public func flatMapLatest<T>(observableCancel: Observable<T>, observableFactory: @escaping (E) throws -> Observable<T>) -> Observable<T> {
        return self
            .flatMapLatest({ element -> Observable<T> in
                return Observable<Observable<T>>
                    .of(observableCancel, try observableFactory(element))
                    .merge()
                    .take(1)
            })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}

public extension Observable {
    
    private typealias Objects = (index: Int, element: E?)
    
    public func enumerated() -> Observable<(index: Int, element: E)> {
        return self
            .scan((index: -1, element: nil), accumulator: { (previous: Objects, element: E?) -> Objects in
                return Objects(index: previous.index &+ 1, element: element)
            })
            .map({ (index: $0.index, element: $0.element!) })
    }
    
    public func takeOnlyFirstNext() -> Observable {
        return self
            .enumerated()
            .filter({ $0.index == 0 })
            .map({ $0.element })
    }
}

public extension Observable {
    
    public func delayCompletion(_ dueTime: RxTimeInterval, scheduler: SchedulerType) -> Observable {
        let observableElement = self
            .observeOn(scheduler)
            .share(replay: 1, scope: .whileConnected)
        let observableCompleted = Observable<Int>
            .timer(0, period: dueTime, scheduler: scheduler)
            .map({ $0 > 0 })
            .share(replay: 1, scope: .whileConnected)
        return Observable<(element: E, completed: Bool)>
            .combineLatest(observableElement, observableCompleted){(element: $0, completed: $1)}
            .filter({ $0.completed })
            .map({ $0.element })
            .take(1)
            .share(replay: 1, scope: .whileConnected)
    }
}

// MARK: - MutexProvider

public extension Observable {
    
    public func protectedFilterMap<M,T>(_ provider: M?, key: AnyHashable, block: @escaping (Element) throws -> (T, Bool)) -> Observable<(Element, T)> where M: MutexProvider {
        return self
            .map({ [weak provider] (element) -> (Element, T, Bool) in
                let value: (T, Bool) = try {
                    switch provider {
                    case .some(let unwrapped):
                        return try unwrapped.mutex(key: key).sync(block: { () -> (T, Bool) in
                            return try block(element)
                        })
                    default:
                        return try block(element)
                    }
                }()
                return (element, value.0, value.1)
            })
            .filter({ $0.2 })
            .map({ ($0.0, $0.1) })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    
    public func protectedFilter<M>(_ provider: M?, key: AnyHashable, block: @escaping (Element) throws -> Bool) -> Observable<Element> where M: MutexProvider {
        return self
            .filter({ (element) -> Bool in
                switch provider {
                case .some(let unwrapped):
                    return try unwrapped.mutex(key: key).sync(block: { () -> Bool in
                        return try block(element)
                    })
                default:
                    return try block(element)
                }
            })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    
    public func protectedMap<M,T>(_ provider: M?, key: AnyHashable, block: @escaping (Element) throws -> (T)) -> Observable<T> where M: MutexProvider {
        return self
            .map({ (element) -> T in
                switch provider {
                case .some(let unwrapped):
                    return try unwrapped.mutex(key: key).sync {
                        return try block(element)
                    }
                default:
                    return try block(element)
                }
            })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    
    public func protectedProceed<M>(_ provider: M?, key: AnyHashable, block: @escaping (Element) throws -> ()) -> Observable<Element> where M: MutexProvider {
        return self
            .map({ (element) -> Element in
                switch provider {
                case .some(let unwrapped):
                    try unwrapped.mutex(key: key).sync {
                        try block(element)
                    }
                default:
                    try block(element)
                }
                return element
            })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}
