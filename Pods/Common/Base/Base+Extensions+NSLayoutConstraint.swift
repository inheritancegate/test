import UIKit

public extension NSLayoutConstraint {
    
    public static func same(attribute: NSLayoutAttribute, constant: CGFloat = 0, item0 item: Any, item1 toItem: Any?, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        Catcher.try({
            constraint = NSLayoutConstraint(
                item: item,
                attribute: attribute,
                relatedBy: relation,
                toItem: toItem,
                attribute: toItem == nil ? .notAnAttribute : attribute,
                multiplier: multiplier,
                constant: constant
            )
        }, catch: { (exception: NSException) in
            fatalError("\(exception)")
        })
        return constraint
    }
}
