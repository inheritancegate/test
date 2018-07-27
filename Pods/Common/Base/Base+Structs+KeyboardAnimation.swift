import UIKit

public struct KeyboardAnimation: NotificationRepresentable, Equatable {
    
    public let curve: UIViewAnimationCurve
    public let duration: TimeInterval
    public let frameBegin: CGRect
    public let frameEnd: CGRect
    /// keyboard will be hidden or is hidden
    public let isHidden: Bool
    /// the start of keyboard animation
    public let isStarted: Bool
    
    init(notification: Notification) {
        curve = getCurve(notification: notification)
        duration = getDuration(notification: notification)
        frameBegin = getFrameBegin(notification: notification)
        frameEnd = getFrameEnd(notification: notification)
        isHidden = getIsHidden(frameEnd: frameEnd)
        isStarted = getIsStarted(notification: notification)
    }
    
    public func convert(to view: UIView?) -> KeyboardAnimation {
        let frameBegin = view?.window?.convert(self.frameBegin, to: view) ?? self.frameBegin
        let frameEnd = view?.window?.convert(self.frameEnd, to: view) ?? self.frameEnd
        return with(frameBegin: frameBegin, frameEnd: frameEnd)
    }
    
    public func with(curve: UIViewAnimationCurve? = nil, duration: TimeInterval? = nil, frameBegin: CGRect? = nil, frameEnd: CGRect? = nil, isHidden: Bool? = nil, isStarted: Bool? = nil) -> KeyboardAnimation {
        return KeyboardAnimation(curve: curve ?? self.curve, duration: duration ?? self.duration, frameBegin: frameBegin ?? self.frameBegin, frameEnd: frameEnd ?? self.frameEnd, isHidden: isHidden ?? self.isHidden, isStarted: isStarted ?? self.isStarted)
    }
    
    public init(curve: UIViewAnimationCurve, duration: TimeInterval, frameBegin: CGRect, frameEnd: CGRect, isHidden: Bool, isStarted: Bool) {
        self.curve = curve
        self.duration = duration
        self.frameBegin = frameBegin
        self.frameEnd = frameEnd
        self.isHidden = isHidden
        self.isStarted = isStarted
    }
    
    public static var bottom: KeyboardAnimation {
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
        return KeyboardAnimation(curve: .linear, duration: 0, frameBegin: frame, frameEnd: frame, isHidden: true, isStarted: false)
    }
    
    public static func notificationRepresentableMapping(_ notification: Notification) -> KeyboardAnimation? {
        return KeyboardAnimation(notification: notification)
    }
    
    public static func notificationRepresentableNames() -> [Notification.Name] {
        return [.UIKeyboardWillChangeFrame, .UIKeyboardDidChangeFrame]
    }
    
    public static func ==(lhs: KeyboardAnimation, rhs: KeyboardAnimation) -> Bool {
        return lhs.duration == rhs.duration && lhs.frameBegin == rhs.frameBegin && lhs.frameEnd == rhs.frameEnd
    }
}

// MARK: -

private func getCurve(notification: Notification) -> UIViewAnimationCurve {
    let rawValue = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 7
    if let curve = UIViewAnimationCurve(rawValue: rawValue) {
        return curve
    }
    return .linear
}

private func getDuration(notification: Notification) -> TimeInterval {
    switch notification.name {
    case .UIKeyboardDidChangeFrame:
        return 0
    default:
        return notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
    }
}

private func getFrameBegin(notification: Notification) -> CGRect {
    return notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect ?? CGRect.zero
}

private func getFrameEnd(notification: Notification) -> CGRect {
    return notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero
}

private func getIsHidden(frameEnd: CGRect) -> Bool {
    let height = UIScreen.main.bounds.height
    if frameEnd.size.height == 0 {
        return true
    } else if frameEnd.origin.y + frameEnd.size.height == height {
        return false
    } else if frameEnd.origin.y == height {
        return true
    } else {
        return frameEnd.origin.y > height
    }
}

private func getIsStarted(notification: Notification) -> Bool {
    switch notification.name {
    case .UIKeyboardDidChangeFrame:
        return false
    default:
        return true
    }
}
