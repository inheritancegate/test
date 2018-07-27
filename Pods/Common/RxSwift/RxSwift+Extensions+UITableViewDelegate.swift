import RxCocoa
import RxSwift
import UIKit

public extension UICollectionViewDelegate {
    
    /// Вызывается только при смене максимального видимого IndexPath
    public func observableGreatestVisibleIndexPath(with view: UICollectionView) -> Observable<IndexPath> {
        weak var object = self as? NSObject
        weak var view = view
        let array: [(Selector, ([Any]) -> Void)] = [
            (#selector(UICollectionViewDelegate.collectionView(_:willDisplay:forItemAt:)), { _ in () }),
            (#selector(UICollectionViewDelegate.scrollViewDidScroll(_:)), { _ in () })
        ]
        let observableShouldCheck = Observable
            .from(array.flatMap({ selector, value in object?.observable(selector: selector, value: value) }))
            .merge()
            .startWith(())
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        let observableTableView = Observable
            .just(view, scheduler: MainScheduler.instance)
            .filterNil()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        return observableShouldCheck
            .withLatestFrom(observableTableView)
            .map({ $0.indexPathsForVisibleItems })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .scan(Optional<IndexPath>.none) { (max, visible) -> IndexPath? in
                return visible.max() ?? max
            }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}

public extension UITableViewDelegate {
    
    /// Вызывается только при смене максимального видимого IndexPath
    public func observableGreatestVisibleIndexPath(with view: UITableView) -> Observable<IndexPath> {
        weak var object = self as? NSObject
        weak var view = view
        let array: [(Selector, ([Any]) -> Void)] = [
            (#selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:)), { _ in () }),
            (#selector(UITableViewDelegate.scrollViewDidScroll(_:)), { _ in () })
        ]
        let observableShouldCheck = Observable
            .from(array.flatMap({ selector, value in object?.observable(selector: selector, value: value) }))
            .merge()
            .startWith(())
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        let observableTableView = Observable
            .just(view, scheduler: MainScheduler.instance)
            .filterNil()
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        return observableShouldCheck
            .withLatestFrom(observableTableView)
            .map({ $0.indexPathsForVisibleRows })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .filterNil()
            .scan(Optional<IndexPath>.none) { (max, visible) -> IndexPath? in
                return visible.max() ?? max
            }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}
