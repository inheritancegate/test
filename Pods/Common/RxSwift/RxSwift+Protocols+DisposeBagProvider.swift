import RxSwift

public protocol DisposeBagProvider: class {
    
    var disposeBag: DisposeBag { get set }
}

private var DISPOSE_BAG_PROVIDER_ASSOCIATED_OBJECT_KEY: UInt8 = 0

public extension DisposeBagProvider {
    
    var disposeBag: DisposeBag {
        get {
            if let value = objc_getAssociatedObject(self, &DISPOSE_BAG_PROVIDER_ASSOCIATED_OBJECT_KEY) as? DisposeBag {
                return value
            } else {
                let value = DisposeBag()
                let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                objc_setAssociatedObject(self, &DISPOSE_BAG_PROVIDER_ASSOCIATED_OBJECT_KEY, value, policy)
                return value
            }
        }
        set(value) {
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &DISPOSE_BAG_PROVIDER_ASSOCIATED_OBJECT_KEY, value, policy)
        }
    }
}
