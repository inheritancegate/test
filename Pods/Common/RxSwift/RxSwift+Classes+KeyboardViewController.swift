import RxCocoa
import RxSwift
import UIKit

open class KeyboardViewController: UIViewController {
    
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var disposeBag: DisposeBag?
    public weak var keyboardOwner: KeyboardOwner? = nil {
        didSet {
            keyboardOwnerUpdate()
        }
    }
    private var keyboardOwnerNotificationAllowed = false
    
    private func keyboardOwnerUpdate() {
        let disposeBag = DisposeBag()
        defer {
            self.disposeBag = disposeBag
        }
        guard keyboardOwner != nil else {
            return
        }
        observableViewState(states: [.didAppear], when: .afterMessageIsInvoked)
            .whileDebugPreconditionThreadIsMain()
            .bind(onNext: { [weak controller = self] _ in
                controller?.keyboardOwner?.keyboardOwning(allowed: true)
                controller?.keyboardOwnerNotificationAllowed = false
            })    
            .disposed(by: disposeBag)
        observableViewState(states: [.willDisappear, .willAppear], when: .beforeMessageIsInvoked)
            .whileDebugPreconditionThreadIsMain()
            .bind(onNext: { [weak controller = self] _ in
                controller?.keyboardOwnerNotificationAllowed = true
            })
            .disposed(by: disposeBag)
        observableViewState(states: [.didDisappear], when: .afterMessageIsInvoked)
            .whileDebugPreconditionThreadIsMain()
            .bind(onNext: { [weak controller = self] _ in
                controller?.keyboardOwner?.keyboardOwning(allowed: false)
                controller?.keyboardOwnerNotificationAllowed = false
            })
            .disposed(by: disposeBag)
    }
    
    private static let _observableKeyboard = NotificationCenter.default.rx
        .observe(with: KeyboardAnimation.self)
        .whileDebugPreconditionThreadIsMain()
        .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    
    public func observableKeyboard() -> Observable<KeyboardAnimation> {
        return KeyboardViewController._observableKeyboard
    }
}
