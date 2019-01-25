import Foundation

public final class AssetDepositAddressOperation: RequestOperation {
    public typealias ResultData = Address

    public lazy private(set) var path: String = "/api/uc/v1/me/assets/\(param.assetPairUUID)/address"

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension AssetDepositAddressOperation {
    public struct Param: Equatable {

        public let assetPairUUID: String

        public init(assetPairUUID: String) {
            self.assetPairUUID = assetPairUUID
        }
    }
}
