import AsyncDisplayKit

public extension ASCollectionNode {
    
    public func update(with updates: Updates, animated: Bool, completion: ((Bool) -> ())? = nil, exception: ((NSException) -> ())? = nil) {
        whileDebugPrecondition(Thread.isMainThread == true)
        Catcher.try({ [weak self] in
            self?.performBatch(animated: animated, updates: { [weak self] in
                self?.deleteItems(at: updates.row.delete)
                self?.insertItems(at: updates.row.insert)
                self?.reloadItems(at: updates.row.reload)
                for (at, to) in updates.row.move {
                    self?.moveItem(at: at, to: to)
                }
                self?.deleteSections(updates.section.delete)
                self?.insertSections(updates.section.insert)
                self?.reloadSections(updates.section.reload)
            }, completion: completion)
        }, catch: { [weak self, updates] object in
            #if DEBUG
                _ = updates
                fatalError("\(object)")
            #else
                self?.reloadData()
                completion?(false)
                exception?(object)
            #endif
        })
    }
}
