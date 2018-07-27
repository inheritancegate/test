import AsyncDisplayKit

public extension ASTableNode {
    
    public func update(with updates: Updates, animated: Bool, completion: ((Bool) -> ())? = nil, exception: ((NSException) -> ())? = nil) {
        whileDebugPrecondition(Thread.isMainThread == true)
        Catcher.try({ [weak self] in
            self?.performBatch(animated: animated, updates: { [weak self] in
                self?.deleteRows(at: updates.row.delete, with: UITableViewRowAnimation.fade)
                self?.insertRows(at: updates.row.insert, with: UITableViewRowAnimation.fade)
                self?.reloadRows(at: updates.row.reload, with: UITableViewRowAnimation.fade)
                for (at, to) in updates.row.move {
                    self?.moveRow(at: at, to: to)
                }
                self?.deleteSections(updates.section.delete, with: UITableViewRowAnimation.fade)
                self?.insertSections(updates.section.insert, with: UITableViewRowAnimation.fade)
                self?.reloadSections(updates.section.reload, with: UITableViewRowAnimation.fade)
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
