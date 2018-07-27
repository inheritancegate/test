import UIKit

// MARK: - UICollectionViewCell

public extension UICollectionView {
    
    func cellDequeue<T: UICollectionViewCell>(_ identifier: String? = nil, indexPath: IndexPath) -> T {
        let identifier = identifier ?? String(describing: T.self)
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
        switch cell {
        case .some(let unwrapped):
            return unwrapped
        default:
            fatalError("Unable to dequeue" + T.self.description())
        }
    }
    
    func cellRegister<T: UICollectionViewCell>(_ type: T.Type, identifier: String? = nil) {
        let identifier = identifier ?? String(describing: T.self)
        register(type, forCellWithReuseIdentifier: identifier)
    }
}

// MARK: - UICollectionReusableView

public extension UICollectionView {
    
    func supplementaryDequeue<T: UICollectionReusableView>(_ identifier: String? = nil, indexPath: IndexPath, kind: String) -> T {
        let identifier = identifier ?? String(describing: T.self)
        let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T
        switch view {
        case .some(let unwrapped):
            return unwrapped
        default:
            fatalError("Unable to dequeue" + T.self.description())
        }
    }
    
    func supplementaryRegister<T: UICollectionReusableView>(_ type: T.Type, identifier: String? = nil, kind: String) {
        let identifier = identifier ?? String(describing: T.self)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}

public extension UICollectionView {
    
    public func update(with updates: Updates, completion: ((Bool) -> ())? = nil, exception: ((NSException) -> ())? = nil) {
        whileDebugPrecondition(Thread.isMainThread == true)
        guard window != nil else {
            reloadData()
            return
        }
        Catcher.try({ [weak self] in
            self?.performBatchUpdates({ [weak self] in
                let move = updates.row.move.filter({ $0.0 != $0.1 })
                let reload = updates.row.move.filter({ $0.0 == $0.1 }).map({ $0.0 })
                self?.deleteItems(at: updates.row.delete + move.map({ $0.0 }))
                self?.insertItems(at: updates.row.insert + move.map({ $0.1 }))
                self?.reloadItems(at: updates.row.reload + reload)
                self?.deleteSections(updates.section.delete)
                self?.insertSections(updates.section.insert)
                self?.reloadSections(updates.section.reload)
            }, completion: completion)
        }, catch: { [weak self, updates] object in
            whileDebug(debug: {
                _ = updates
                fatalError("\(object)")
            }, release: {
                self?.reloadData()
                exception?(object)
            })
        })
    }
}
