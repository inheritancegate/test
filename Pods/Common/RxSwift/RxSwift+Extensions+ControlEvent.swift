import RxCocoa
import RxSwift

public extension ControlEvent {
    
    public static func never() -> ControlEvent {
        return ControlEvent.init(events: Observable.never())
    }
}
