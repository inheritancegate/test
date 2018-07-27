import RxCocoa
import RxSwift
import UIKit

public extension UICollectionView {
    
    public func observableCurrentPage() -> Observable<Int> {
        return rx.contentOffset
            .map({ $0.x })
            .filter({ $0 >= 0 })
            .map({ [weak view = self] (x) -> Int? in
                let width = view?.bounds.size.width ?? 0
                guard width > 0 else {
                    return nil
                }
                return Int(ceil(x/width))
            })
            .filterNil()
            .distinctUntilChanged()
    }
}
