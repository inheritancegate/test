import Common
/// Сервис контролирования пользовательских жестов, который отключает/включает жесты через UIApplication.shared
public func getUserInteractionService() -> UserInteractionServiceType {
    return getUserInteractionService(ignoringBegin: {
        switch Thread.isMainThread {
        case true:
            UIApplication.shared.beginIgnoringInteractionEvents()
        case false:
            DispatchQueue.main.async {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }, ignoringComplete: {
        switch Thread.isMainThread {
        case true:
            UIApplication.shared.endIgnoringInteractionEvents()
        case false:
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }, ignoringTimeout: { (file: String, line: Int) in
        whileDebugPrint("User intercation timeout exceeded", line, file)
    })
}
