import UIKit

// MARK: - SeparatorProvider

public protocol SeparatorProvider: class {

    var separator: Separator { get }
}

private var SEPARATOR_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension SeparatorProvider {

    var separator: Separator {
        if let separator = objc_getAssociatedObject(self, &SEPARATOR_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY) as? Separator {
            return separator
        } else {
            let separator = Separator()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &SEPARATOR_PROVIDER_HOLDER_ASSOCIATED_OBJECT_KEY, separator, policy)
            return separator
        }
    }
}

public final class Separator {

    private lazy var viewSeparator = self.getViewSeparator()

    private func getViewSeparator() -> UIView {
        let view = UIView()
        view.layer.zPosition = CGFloat.greatestFiniteMagnitude
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    public func remove() {
        self.update()
    }

    public func update(bottom: Bool = true, color: UIColor = UIColor.red, height: CGFloat = 1, left: CGFloat = 0, right: CGFloat = 0, view: UIView? = nil) {
        viewSeparator.removeFromSuperview()
        guard let view = view else {
            return
        }
        Catcher.try({
            viewSeparator.backgroundColor = color
            view.addSubview(viewSeparator)
            view.sendSubview(toBack: viewSeparator)
            var constraints = [NSLayoutConstraint]()
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(left)-[V]-\(right)-|", options: [], metrics: nil, views: ["V": viewSeparator])
            switch bottom {
            case true:
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[V(\(height))]|", options: [], metrics: nil, views: ["V": viewSeparator])
            case false:
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[V(\(height))]", options: [], metrics: nil, views: ["V": viewSeparator])
            }
            NSLayoutConstraint.activate(constraints)
        }, catch: { (exception) in
            print(exception)
        })
    }
}
