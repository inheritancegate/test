import UIKit

public extension UITableView {
    
    func cellDequeue<T: UITableViewCell>(identifier: String? = nil, indexPath: IndexPath) -> T {
        let identifier: String = identifier ?? String(describing: T.self)
        switch dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
        case .some(let cell):
            return cell
        default:
            fatalError("Unable to dequeue " + T.self.description())
        }
    }
    
    func cellRegister<T: UITableViewCell>(identifier: String? = nil, type: T.Type) {
        let identifier: String = identifier ?? String(describing: T.self)
        register(type, forCellReuseIdentifier: identifier)
    }
    
    func headerFooterDequeue<T: UITableViewHeaderFooterView>(identifier: String? = nil) -> T {
        let identifier: String = identifier ?? String(describing: T.self)
        switch dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T {
        case .some(let view):
            return view
        default:
            fatalError("Unable to dequeue " + T.self.description())
        }
    }
    
    func headerFooterRegister<T: UITableViewHeaderFooterView>(identifier: String? = nil, type: T.Type) {
        let identifier: String = identifier ?? String(describing: T.self)
        register(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

public enum UITableViewUpdateType {
    /// все обновления происходят через анимацию одного типа
    case equal(UITableViewRowAnimation)
    /// delete + reload ~> bottom, insert + reload ~> top
    case vertical
}

public extension UITableView {
    /// Если произойдет NSException, то будет вызван метод reloadData. Дополнительно обновлять UITableView не следует.
    public func update(with updates: Updates, type: UITableViewUpdateType, completion: (() -> ())? = nil, exception: ((NSException) -> ())? = nil) {
        let time: CFAbsoluteTime? = nil// = CFAbsoluteTimeGetCurrent()
        switch (Thread.isMainThread, window) {
        case (false, _), (_, .none):
            updateReload(completion: completion, time: time, updates: updates)
        default:
            updateNormal(completion: completion, exception: exception, time: time, type: type, updates: updates)
        }
    }
    
    private func updateNormal(completion: (() -> ())?, exception: ((NSException) -> ())?, time: CFAbsoluteTime?, type: UITableViewUpdateType, updates: Updates) {
        Catcher.try({ [weak self] in
            let closure: () -> Void = {
                switch type {
                case .equal(let animation):
                    return self?.updateClosureEqual(updates: updates, animation: animation) ?? {}
                case .vertical:
                    return self?.updateClosureVertical(updates: updates) ?? {}
                }
            }()
            if #available(iOS 11.0, *) {
                performBatchUpdates(closure, completion: { _ in
                    completion?()
                    time?.showIfExceeds(delay: 1)
                })
            } else {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    completion?()
                    time?.showIfExceeds(delay: 1)
                })
                beginUpdates()
                closure()
                endUpdates()
                CATransaction.commit()
            }
         }, catch: { [weak self, updates] object in
            #if DEBUG
            weak var window = self?.window
            let controller = UIAlertController(title: "\(object)", message: "\(updates)", preferredStyle: .alert)
            if let presented = window?.rootViewController?.presentedViewController {
                presented.dismiss(animated: false, completion: {
                    window?.rootViewController?.present(controller, animated: false)
                })
            } else {
                window?.rootViewController?.present(controller, animated: false)
            }
            #else
            self?.reloadData()
            exception?(object)
            completion?()
            time?.showIfExceeds(delay: 1)
            #endif
        })
    }
    
    private func updateReload(completion: (() -> ())?, time: CFAbsoluteTime?, updates: Updates) {
        switch Thread.isMainThread {
        case true:
            reloadData()
            completion?()
            time?.showIfExceeds(delay: 1)
        case false:
            DispatchQueue.main.async { [weak self] in
                self?.updateReload(completion: completion, time: time, updates: updates)
            }
        }
    }
}

public extension CFAbsoluteTime {
    
    public func showIfExceeds(delay: Double, extra: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        let milliseconds = (CFAbsoluteTimeGetCurrent() - self) * 1000
        if milliseconds > delay {
            let extra: String = {
                switch extra {
                case .some(let extra):
                    return "\nextra: \(extra)"
                case .none:
                    return ""
                }
            }()
            print("\ndelay: \(milliseconds) ms\(extra)\nline: \(line)\nfile: \(file)\nfunction: \(function)\n")
        }
    }
}

extension UITableView {
    
    func updateClosureEqual(updates: Updates, animation: UITableViewRowAnimation) -> () -> Void {
        return { [weak self] () in
            self?.deleteRows(at: updates.row.delete, with: animation)
            self?.insertRows(at: updates.row.insert, with: animation)
            self?.reloadRows(at: updates.row.reload, with: animation)
            for (at, to) in updates.row.move {
                self?.moveRow(at: at, to: to)
            }
            self?.insertSections(updates.section.insert, with: animation)
            self?.deleteSections(updates.section.delete, with: animation)
            self?.reloadSections(updates.section.reload, with: animation)
        }
    }
    
    func updateClosureVertical(updates: Updates) -> () -> Void  {
        return { [weak self] () in
            self?.deleteRows(at: updates.row.delete + updates.row.reload, with: UITableViewRowAnimation.bottom)
            self?.insertRows(at: updates.row.insert + updates.row.reload, with: UITableViewRowAnimation.top)
            for (at, to) in updates.row.move {
                self?.moveRow(at: at, to: to)
            }
            self?.deleteSections(updates.section.delete.union(updates.section.reload), with: UITableViewRowAnimation.bottom)
            self?.insertSections(updates.section.insert.union(updates.section.reload), with: UITableViewRowAnimation.top)
        }
    }
}
