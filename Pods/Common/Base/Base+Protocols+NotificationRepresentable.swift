import UIKit

public protocol NotificationRepresentable {
    
    static func notificationRepresentableMapping(_ notification: Notification) -> Self?
    static func notificationRepresentableNames() -> [Notification.Name]
}
