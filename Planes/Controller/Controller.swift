import AsyncDisplayKit
import Common
import RxCocoa
import RxSwift
import UIPanGestureRecognizerDirection

final class Controller: TXViewController, ControllerCellDelegate {
    
    private var revealed = Set<IndexPath>()
    private lazy var providerBackground = self.getProviderBackground()
    private lazy var providerTable = self.getProviderTable()
    
    init() {
        super.init()
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = { [weak controller = self] _, _ in
            return controller?.layoutSpec ?? ASLayoutSpec()
        }
        providerTable.node.dataSource = self
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func controllerCell(_ cell: ASCellNode, shouldChangeStyleTo revealed: Bool) {
        guard let indexPath = providerTable.node.indexPath(for: cell) else {
            return
        }
        switch (revealed, self.revealed.contains(indexPath)) {
        case (true, false):
            self.revealed.insert(indexPath)
            self.providerTable.node.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        case (false, true):
            self.revealed.remove(indexPath)
            self.providerTable.node.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        default:
            break
        }
    }
}

protocol ControllerCellDelegate: class {
    
    func controllerCell(_ cell: ASCellNode, shouldChangeStyleTo revealed: Bool)
}

extension Controller: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch self.revealed.contains(indexPath) {
        case true:
            return { [weak delegate = self] in
                let cell = CellFull()
                cell.delegate = delegate
                return cell
            }
        case false:
            return { [weak delegate = self] in
                let cell = CellShort()
                cell.delegate = delegate
                return cell
            }
        }
    }
}

// MARK: - Layout

private extension Controller {
    
    var layoutSpec: ASLayoutSpec {
        let spec0 = providerTable.layoutSpec
        let spec1 = ASInsetLayoutSpec(insets: safeAreaInsetsChange.safeAreaInsets, child: spec0)
        let spec2 = providerBackground.layoutSpec
        let spec3 = ASOverlayLayoutSpec.with(elements: spec2, spec1)
        return spec3
    }
}

// MARK: - Providers

private extension Controller {
    
    func getProviderBackground() -> ASLayoutSpecProvider {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.orange
        node.isLayerBacked = true
        return ASNodeProvider(node: node)
    }
    
    func getProviderTable() -> ASNodeProvider<ASTableNode> {
        let node = ASTableNode(style: .plain)
        node.backgroundColor = UIColor(white: 240 / 255, alpha: 1)
        node.contentInset = UIEdgeInsets(bottom: 16)
        node.onDidLoad { [weak node] _ in
            node?.view.panGestureRecognizer.direction = .vertical
            node?.view.separatorStyle = .none
        }
        return ASNodeProvider<ASTableNode>(node: node)
    }
}

// MARK: - Cells

private extension Controller {
    
    final class CellFull: ASCellNode, ControllerFullFlightSpecProviderDelegate {

        weak var delegate: ControllerCellDelegate?
        private lazy var providerBackground = self.getProviderBackground()
        private lazy var providersFlight = self.getProvidersFlight()
        private lazy var providersTransfer = self.getProvidersTransfer()
        
        override init() {
            super.init()
            self.automaticallyManagesSubnodes = true
            self.selectionStyle = .none
            providersFlight
                .enumerated()
                .map({ (disclosure: $0.offset == 0, provider: $0.element) })
                .forEach({ [weak cell = self] (disclosure, provider) in
                    provider.delegate = cell
                    let conveniences: [(image: UIImage?, text: String)] = [
                        (UIImage(named: "ic_wifi"), "Wi-Fi is enabled"),
                        (UIImage(named: "ic_wifi"), "No power outlets"),
                        (UIImage(named: "ic_wifi"), "In-flight entertainment is available"),
                        (UIImage(named: "ic_wifi"), "Average legroom (31 in)")
                    ]
                    let dateAttributedText = NSAttributedString.with(color: .black, height: .force(20), size: 13, text: "30 мая 2018 г.", weight: .semibold)
                    let directionAttributedText = NSAttributedString.with(color: .black, height: .force(20), position: .bottom(0), size: 16, text: "JFK, New York - CMN, Casablanca", weight: .semibold)
                    let durationAttributedText = NSAttributedString.with(color: .white, size: 13, text: "6 h 50 min", weight: .semibold)
                    let intervalAttributedTexts = [
                        NSAttributedString.with(color: .black, height: .force(20), size: 13, text: "21.00 — 7.50", weight: .semibold),
                        NSAttributedString.with(color: .black, height: .force(20), position: .center(4), size: 8, text: " +1", weight: .semibold)
                    ]
                    let intervalAttributedText = intervalAttributedTexts.compactMap({ $0 }).reduce(into: NSMutableAttributedString(), { $0.append($1) })
                    provider.set(
                        conveniences: conveniences,
                        dateAttributedText: dateAttributedText,
                        directionAttributedText: directionAttributedText,
                        disclosure: disclosure,
                        durationAttributedText: durationAttributedText,
                        intervalAttributedText: intervalAttributedText,
                        plane: (
                            URL(string: "https://www.marketing91.com/wp-content/uploads/2017/11/SWOT-analysis-of-Lufthansa-Airlines-1.jpg"),
                            NSAttributedString.with(color: .black, height: .force(20), size: 16, text: "Royal Air Maroc, AT 201 asdf asdf ", weight: .regular)
                        )
                    )
                })
            providersTransfer
                .forEach({ (provider) in
                    let airportAttributedText = NSAttributedString.with(color: .black, height: .force(20), size: 16, text: "CMN, Casablanca", weight: .regular)
                    let layoverAttributedText = NSAttributedString.with(color: .lightGray, height: .force(20), size: 16, text: "Layover 4 ч 40 мин", weight: .regular)
                    provider.set(airportAttributedText: airportAttributedText, layoverAttributedText: layoverAttributedText)
                })
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            
            let children = providersFlight
                .count
                .enumeration
                .map({ [providersFlight.object(at: $0)?.layoutSpec, providersTransfer.object(at: $0)?.layoutSpec] })
                .flatMap({ $0 })
                .compactMap({ $0 })
            let spec2 = ASStackLayoutSpec.vertical(
                justifyContent: .start,
                alignItems: .stretch,
                children: children
            )
            let spec3 = ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 12, left: 12, right: 12, top: 12), child: spec2)
            let spec4 = providerBackground.layoutSpec
            let spec5 = ASBackgroundLayoutSpec.with(elements: spec3, spec4)
            let spec6 = ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 8, left: 16, right: 16, top: 8), child: spec5)
            return spec6
        }
        
        func controllerFullFlightSpecProvider(_ provider: ControllerFullFlightSpecProvider, didReceiveTouchUpInsideEvent: Void) {
            delegate?.controllerCell(self, shouldChangeStyleTo: false)
        }
        
        private func getProviderBackground() -> ASLayoutSpecProvider {
            let image = UIImage.with(background: UIColor(white: 240 / 255, alpha: 1), border: Border(color: UIColor(white: 0.9, alpha: 1.0), width: 1), foreground: .white, radius: 8)
            let node = ASImageNode()
            node.image = image?.stretchableImage(withLeftCapWidth: 8, topCapHeight: 8)
            return ASNodeProvider(node: node)
        }
        
        private func getProvidersFlight() -> [ControllerFullFlightSpecProvider] {
            return [ControllerFullFlightSpecProvider(), ControllerFullFlightSpecProvider(), ControllerFullFlightSpecProvider()]
        }
        
        private func getProvidersTransfer() -> [ControllerFullTransferSpecProvider] {
            return [ControllerFullTransferSpecProvider(), ControllerFullTransferSpecProvider()]
        }
    }
    
    final class CellShort: ASCellNode, ControllerShortDurationIntervalSpecProviderDelegate {
        
        weak var delegate: ControllerCellDelegate?
        private lazy var providerBackground = self.getProviderBackground()
        private(set) lazy var providerDetails = ControllerShortDetailsSpecProvider()
        private(set) lazy var providerSchedule = ControllerShortDurationIntervalSpecProvider()
        
        override init() {
            super.init()
            self.automaticallyManagesSubnodes = true
            self.selectionStyle = .none
            
            let durationAttributedText = NSAttributedString.with(color: .white, size: 13, text: "1 h 25 min", weight: .semibold)
            let intervalAttributedTexts = [
                NSAttributedString.with(color: .black, height: .force(18), position: .bottom(0.5), size: 16, text: "7:55", weight: .semibold),
                NSAttributedString.with(color: .black, height: .force(18), position: .bottom(0), size: 13, text: " AM", weight: .regular),
                NSAttributedString.with(color: .black, height: .force(18), position: .bottom(0), size: 16, text: " — ", weight: .semibold),
                NSAttributedString.with(color: .black, height: .force(18), position: .bottom(0.5), size: 16, text: "8:56", weight: .semibold),
                NSAttributedString.with(color: .black, height: .force(18), position: .bottom(0), size: 13, text: " PM", weight: .regular)
            ]
            let intervalAttributedText = intervalAttributedTexts.compactMap({ $0 }).reduce(into: NSMutableAttributedString(), { $0.append($1) })
            providerSchedule.set(
                durationAttributedText: durationAttributedText,
                intervalAttributedText: intervalAttributedText
            )
            let airlineAttributedText = NSAttributedString.with(color: .black, size: 13, text: "Lufthansa", weight: .regular)
            let image = URL(string: "https://www.marketing91.com/wp-content/uploads/2017/11/SWOT-analysis-of-Lufthansa-Airlines-1.jpg")
            let matchAttributedText = NSAttributedString.with(color: UIColor(white: 0.75, alpha: 1.0), size: 13, text: "94%", weight: .semibold)
            let priceBorderColor = UIColor(red: 30/255, green: 150/255, blue: 110/255, alpha: 1)
            let priceAttributedText = NSAttributedString.with(color: priceBorderColor, size: 16, text: "$297.51", weight: .semibold)
            providerDetails.set(
                airlineAttributedText: airlineAttributedText,
                image: image,
                matchAttributedText: matchAttributedText,
                priceAttributedText: priceAttributedText,
                priceBorderColor: priceBorderColor
            )
        }
        
        override func didLoad() {
            super.didLoad()
            providerSchedule.delegate = self
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            let spec0 = providerSchedule.layoutSpec
            let spec1 = providerDetails.layoutSpec
            let spec2 = ASStackLayoutSpec.vertical(
                justifyContent: .start,
                alignItems: .stretch,
                children: [
                    spec0,
                    ASLayoutSpec.getSpacer(height: 12),
                    spec1
                ]
            )
            let spec3 = ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 12, left: 12, right: 12, top: 12), child: spec2)
            let spec4 = providerBackground.layoutSpec
            let spec5 = ASBackgroundLayoutSpec.with(elements: spec3, spec4)
            let spec6 = ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 8, left: 16, right: 16, top: 8), child: spec5)
            return spec6
        }
        
        func controllerShortDurationIntervalSpecProvider(_ provider: ControllerShortDurationIntervalSpecProvider, didReceiveTouchUpInsideEvent: Void) {
            delegate?.controllerCell(self, shouldChangeStyleTo: true)
        }
        
        private func getProviderBackground() -> ASLayoutSpecProvider {
            let provider = SpecProviderBackground()
            provider.set(
                backgroundColor: .white,
                border: Border(color: UIColor(white: 0.9, alpha: 1.0), width: 1),
                corners: Corners(color: UIColor(white: 240 / 255, alpha: 1), radius: 8)
            )
            return provider
        }
    }
}
