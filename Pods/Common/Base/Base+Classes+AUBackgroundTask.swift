import Foundation

public final class AUBackgroundTask {
    
    public var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid {
        didSet {
            identifierMutex.sync {
                if identifierPrepared == false, let workItemTimeout = self.workItemTimeout {
                    whileDebug {
                        if logs {
                            whileDebugPrint("AUBackgroundTask identifier", Date().timeIntervalSince1970)
                        }
                    }
                    workItemUnused?.cancel()
                    workItemUnused = nil
                    let deadline: DispatchTime = .now() + delay
                    DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItemTimeout)
                }
                identifierPrepared = true
            }
        }
    }
    
    public init(delay: TimeInterval, logs: Bool = false, timeout: (() -> ())? = nil, unused: (() -> ())? = nil) {
        whileDebug {
            if logs {
                whileDebugPrint("AUBackgroundTask init", Date().timeIntervalSince1970)
            }
        }
        self.delay = delay
        self.logs = logs
        self.timeout = timeout
        self.unused = unused
        if let workItemUnused = self.workItemUnused {
            let deadline: DispatchTime = .now() + delay
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItemUnused)
        }
    }
    
    let delay: TimeInterval
    let logs: Bool
    var identifierMutex = Mutex()
    var identifierPrepared: Bool = false
    let timeout: (() -> ())?
    let unused: (() -> ())?
    lazy var workItemTimeout = self.getWorkItemTimeout()
    lazy var workItemUnused = self.getWorkItemUnused()
    
    func getWorkItemTimeout() -> DispatchWorkItem? {
        if timeout != nil {
            return DispatchWorkItem(block: { [weak task = self] in
                task?.timeout?()
            })
        }
        return nil
    }
    
    func getWorkItemUnused() -> DispatchWorkItem? {
        if unused != nil {
            return DispatchWorkItem(block: { [weak task = self] in
                task?.unused?()
            })
        }
        return nil
    }
    
    deinit {
        whileDebug {
            if logs {
                whileDebugPrint("AUBackgroundTask deinit", Date().timeIntervalSince1970)
            }
        }
        workItemTimeout?.cancel()
        workItemTimeout = nil
        workItemUnused?.cancel()
        workItemUnused = nil
    }
}
