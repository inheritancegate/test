import AsyncDisplayKit
import RxCocoa
import RxSwift
import UIKit

// MARK: - TXViewController

open class TXViewController: ASViewController<TXNode>, DisposeBagProvider {
    ///
    public static let animationKeyDefault = "\(#file)_\(#line)"
    ///
    public static let animationKeyKeyboard = "\(#file)_\(#line)"
    /// TXViewControllerInsetsDelegate
    public weak var delegateInsets: TXViewControllerInsetsDelegate?
    /// If YES, then when this view controller is pushed into a controller hierarchy with a bottom bar (like a tab bar), the bottom bar will slide out. Default is NO.
    open override var hidesBottomBarWhenPushed: Bool {
        get {
            switch navigationController?.topViewController {
            case .some(let controller):
                switch controller == self {
                case true:
                    return super.hidesBottomBarWhenPushed
                case false:
                    return false
                }
            default:
                return super.hidesBottomBarWhenPushed
            }
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    /// Владелец клавиатуры
    public weak var keyboardOwner: KeyboardOwner? = nil {
        didSet {
            keyboardOwnerUpdate()
        }
    }
    /// DisposeBag, который используется только для keyboardOwner
    private var keyboardOwnerDisposeBag: DisposeBag?

    /// Глобальный сигнал клавиатуры (чтобы не плодить сигналы)
    private static let observableKeyboard = NotificationCenter.default.rx
        .observe(with: KeyboardAnimation.self)
        .whileDebugPreconditionThreadIsMain()
        .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    /// Последние изменение отступов
    public private(set) lazy var safeAreaInsetsChange: TXSafeAreaInsetsChange = TXSafeAreaInsetsChange(curve: .linear, duration: 0, safeAreaInsets: self.getSafeAreaInsets(), safeKeyboardInsets: self.getSafeKeyboardInsets(keyboardAnimation: .bottom))
    /// Мьютекс для синхронизации изменения/чтения отступов
    private let safeAreaInsetsChangeMutex = Mutex()
    
    public init(keyboardOwner: KeyboardOwner? = nil) {
        let node = TXNode()
        super.init(node: node)
        self.delegateInsets = self
        self.keyboardOwner = keyboardOwner
    }
    
    internal lazy var curve: UIViewAnimationCurve = .linear
    internal lazy var duration: TimeInterval = 0
    internal lazy var key: String = TXViewController.animationKeyDefault
    
    public func transitionLayout(curve: UIViewAnimationCurve = .linear, duration: TimeInterval = 0, key: String = TXViewController.animationKeyDefault, measureAsync shouldMeasureAsync: Bool, measureComplete measurementCompletion: (() -> Void)? = nil) {
        assert(duration >= 0, "Время анимации не должно быть открицательным")
        self.curve = curve
        self.duration = duration
        self.key = key
        let withAnimation = duration > 0
        node.transitionLayoutAllowed = true
        node.transitionLayout(withAnimation: withAnimation, shouldMeasureAsync: shouldMeasureAsync, measurementCompletion: measurementCompletion)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let observableKeyboardAnimation = self.observableKeyboardAnimationOnDidAppear()
        let observableSafeAreaInsets = self.observableSafeAreaInsets()
        let observableSafeAreaInsetsChange = self.observableSafeAreaInsetsChange(observableKeyboardAnimation, observableSafeAreaInsets)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
}

// MARK: -

private extension TXViewController {
    
    var observerSafeAreaInsetsChange: AnyObserver<TXSafeAreaInsetsChange> {
        return Binder(self, scheduler: MainScheduler.instance, binding: { (controller: TXViewController, safeAreaInsetsChange: TXSafeAreaInsetsChange) in
            controller.safeAreaInsetsChangeMutex.sync {
                controller.safeAreaInsetsChange = safeAreaInsetsChange
            }
            let curve = safeAreaInsetsChange.curve
            let duration = safeAreaInsetsChange.duration
            let safeAreaInsets = safeAreaInsetsChange.safeAreaInsets
            let safeKeyboardInsets = safeAreaInsetsChange.safeKeyboardInsets
            controller.delegateInsets?.controllerInsetsDidChange(controller, curve: curve, duration: duration, safeAreaInsets: safeAreaInsets, safeKeyboardInsets: safeKeyboardInsets)
        }).asObserver()
    }
}

// MARK: -

private extension TXViewController {
    /// Обновить владельца клавиатуры, т.е. сбросить старые настройки и переподписать всех наблюдателей
    func keyboardOwnerUpdate() {
        let keyboardOwnerDisposeBag = DisposeBag()
        defer {
            self.keyboardOwnerDisposeBag = keyboardOwnerDisposeBag
        }
        guard keyboardOwner != nil else {
            return
        }
        observableViewState(states: [.didAppear], when: .afterMessageIsInvoked)
            .whileDebugPreconditionThreadIsMain()
            .bind(onNext: { [weak controller = self] _ in
                controller?.keyboardOwner?.keyboardOwning(allowed: true)
            })
            .disposed(by: keyboardOwnerDisposeBag)
        observableViewState(states: [.didDisappear], when: .afterMessageIsInvoked)
            .whileDebugPreconditionThreadIsMain()
            .bind(onNext: { [weak controller = self] _ in
                controller?.keyboardOwner?.keyboardOwning(allowed: false)
            })
            .disposed(by: keyboardOwnerDisposeBag)
    }
}

// MARK: -

private extension TXViewController {
    /// сигнал изменения клавиатуры с фильтрацией неактивного состояния контролера
    func observableKeyboardAnimationOnDidAppear() -> Observable<KeyboardAnimation> {
        return observableViewState(states: [.didAppear], when: .beforeMessageIsInvoked)
            .take(1)
            .flatMap({ [weak controller = self] _ -> Observable<Bool> in
                return controller?.observableViewState(when: .afterMessageIsInvoked)
                    .distinctUntilChanged()
                    .map({ $0 == .didAppear })
                    .startWith(true)
                    .distinctUntilChanged() ?? Observable<Bool>.never()
            })
            .flatMapLatest({ [weak controller = self] (observe: Bool) -> Observable<KeyboardAnimation> in
                guard observe, let controller = controller else {
                    return Observable.never()
                }
                return controller.observableKeyboardAnimation()
            })
            .startWith(KeyboardAnimation.bottom)
            .distinctUntilChanged()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    /// сигнал изменения отступов контролера
    func observableSafeAreaInsets() -> Observable<UIEdgeInsets> {
        var selectors = [
            #selector(UIViewController.viewDidLayoutSubviews),
            #selector(UIViewController.viewWillLayoutSubviews)
        ]
        if #available(iOS 11.0, *) {
            selectors += [
                #selector(UIViewController.viewLayoutMarginsDidChange),
                #selector(UIViewController.viewSafeAreaInsetsDidChange)
            ]
        }
        let observables = selectors
            .map({ [weak self] (selector) -> Observable<Void> in
                self?.observable(selector: selector, value: { _ in () }, when: InvocationTime.afterMessageIsInvoked) ?? Observable.never()
            })
        let observable0 = Observable
            .from(observables)
            .merge()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        let observable1 = observableViewState()
            .map(to: ())
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        let observable2 = Observable
            .just((), scheduler: MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        return Observable
            .of(observable0, observable1, observable2)
            .merge()
            .map({ [weak controller = self] _ -> UIEdgeInsets? in
                return controller?.getSafeAreaInsets()
            })
            .filterNil()
            .startWith(.zero)
            .distinctUntilChanged()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
    /// сигнал изменения отступов
    func observableSafeAreaInsetsChange(_ observableKeyboardAnimation: Observable<KeyboardAnimation>, _ observableSafeAreaInsets: Observable<UIEdgeInsets>) -> Observable<TXSafeAreaInsetsChange> {
        
        let safeKeyboardInsetsMaker: (KeyboardAnimation, UIEdgeInsets) -> UIEdgeInsets = { [weak controller = self] (keyboardAnimation: KeyboardAnimation, safeAreaInsets: UIEdgeInsets) -> UIEdgeInsets in
            guard let view = controller?.view, let window = view.window else {
                return safeAreaInsets
            }
            let frame = window.convert(keyboardAnimation.frameEnd, to: view)
            let bottom = view.frame.height - frame.origin.y
            return bottom > safeAreaInsets.bottom ? safeAreaInsets.with(bottom: bottom) : safeAreaInsets
        }
        
        let observable0 = observableKeyboardAnimation
            .withLatestFrom(observableSafeAreaInsets){(keyboardAnimation: $0, safeAreaInsets: $1, keyboard: true)}
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        let observable1 = observableSafeAreaInsets
            .withLatestFrom(observableKeyboardAnimation){(keyboardAnimation: $1, safeAreaInsets: $0, keyboard: false)}
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        return Observable
            .of(observable0, observable1)
            .merge()
            .map({ [weak controller = self] (keyboardAnimation, safeAreaInsets, keyboard) -> TXSafeAreaInsetsChange? in
                guard let controller = controller else {
                    return nil
                }
                let curve = keyboard ? keyboardAnimation.curve : .easeOut
                let duration = keyboard ? keyboardAnimation.duration : 0
                let safeKeyboardInsets = safeKeyboardInsetsMaker(keyboardAnimation, safeAreaInsets)
                return TXSafeAreaInsetsChange(curve: curve, duration: duration, safeAreaInsets: safeAreaInsets, safeKeyboardInsets: safeKeyboardInsets)
            })
            .filterNil()
            .distinctUntilChanged()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}

// MARK: -

public extension TXViewController {
    /// сигнал изменения клавиатуры
    public func observableKeyboardAnimation() -> Observable<KeyboardAnimation> {
        return TXViewController.observableKeyboard
    }
}

// MARK: -

public extension TXViewController {
    /// безопасные отступы контролера
    public func getSafeAreaInsets() -> UIEdgeInsets {
        whileDebugPrecondition(Thread.isMainThread == true)
        let selfSafeAreaInsets: UIEdgeInsets = {
            if #available(iOS 11, *) {
                return view.safeAreaInsets
            } else {
                return UIEdgeInsets(bottom: bottomLayoutGuide.length, top: topLayoutGuide.length)
            }
        }()
        guard selfSafeAreaInsets == .zero else {
            return selfSafeAreaInsets
        }
        let superSafeAreaInsets: UIEdgeInsets? = {
            guard let controller = [navigationController, tabBarController].flatMap({ $0 }).first else {
                return nil
            }
            if #available(iOS 11, *) {
                return controller.view.safeAreaInsets
            } else {
                return UIEdgeInsets(bottom: controller.bottomLayoutGuide.length, top: controller.topLayoutGuide.length)
            }
        }()
        return superSafeAreaInsets ?? selfSafeAreaInsets
    }
    /// безопасные отступы учитывая клавиатуру
    private func getSafeKeyboardInsets(keyboardAnimation: KeyboardAnimation, safeAreaInsets: UIEdgeInsets? = nil) -> UIEdgeInsets {
        let safeAreaInsets = safeAreaInsets ?? getSafeAreaInsets()
        guard let view = view, let window = view.window else {
            return safeAreaInsets
        }
        let frame = window.convert(keyboardAnimation.frameEnd, to: view)
        let bottom = view.frame.height - frame.origin.y
        return bottom > safeAreaInsets.bottom ? safeAreaInsets.with(bottom: bottom) : safeAreaInsets
    }
}

extension TXViewController: TXViewControllerInsetsDelegate {
    
    public func controllerInsetsDidChange(_ controller: TXViewController, curve: UIViewAnimationCurve, duration: TimeInterval, safeAreaInsets: UIEdgeInsets, safeKeyboardInsets: UIEdgeInsets) {
        self.curve = curve
        self.duration = duration
        self.key = TXViewController.animationKeyKeyboard
        let withAnimation = duration > 0
        node.transitionLayout(withAnimation: withAnimation, shouldMeasureAsync: false)
    }
}
