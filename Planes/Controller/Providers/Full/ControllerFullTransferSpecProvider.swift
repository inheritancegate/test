import AsyncDisplayKit
import Common

final class ControllerFullTransferSpecProvider: ASLayoutSpecProvider {
    
    private lazy var providerAirport = self.getProviderAirport()
    private lazy var providerLayover = self.getProviderLayover()
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerAirport.layoutSpec
        let spec1 = providerLayover.layoutSpec
        let spec2 = ASStackLayoutSpec.vertical(justifyContent: .start, alignItems: .center, children: [spec0, spec1], spacing: 4)
        let spec3 = ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 16, top: 16), child: spec2)
        return spec3
    }
}

extension ControllerFullTransferSpecProvider {
    
    func set(airportAttributedText: NSAttributedString?, layoverAttributedText: NSAttributedString?) {
        providerAirport.node.attributedText = airportAttributedText
        providerLayover.node.attributedText = layoverAttributedText
    }
}

private extension ControllerFullTransferSpecProvider {
    
    func getProviderAirport() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        if LaunchArguments.debugColors.isEnabled {
            node.backgroundColor = UIColor.orange
        }
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
    
    func getProviderLayover() -> ASNodeProvider<ASTextNode> {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: " ")
        node.backgroundColor = UIColor.white
        if LaunchArguments.debugColors.isEnabled {
            node.backgroundColor = UIColor.green
        }
        node.isOpaque = true
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        let provider = ASNodeProvider(node: node)
        return provider
    }
}
