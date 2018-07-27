import AsyncDisplayKit

public class ASActivityNode: ASDisplayNode {
    
    public private(set) weak var activityIndicatorView: UIActivityIndicatorView?
    
    public convenience init(viewBlock: @escaping () -> UIActivityIndicatorView = { UIActivityIndicatorView(activityIndicatorStyle: .gray) }, completion: ((UIActivityIndicatorView) -> ())?) {
        self.init(viewBlock: viewBlock, didLoad: { (node: ASDisplayNode) in
            if let node = node as? ASActivityNode {
                node.activityIndicatorView = node.view as? UIActivityIndicatorView
            }
            completion?(node.view as? UIActivityIndicatorView ?? UIActivityIndicatorView())
        })
    }
}
