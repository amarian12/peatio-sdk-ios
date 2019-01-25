import Foundation

public final class AssetPairOperation: RequestOperation {
    public typealias ResultData = AssetPair

    public lazy private(set) var path: String = "/api/xn/v1/asset_pairs/\(param.assetPairUUID)"

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension AssetPairOperation {
    public struct Param: Equatable {
        public let assetPairUUID: String

        public init(assetPairUUID: String) {
            self.assetPairUUID = assetPairUUID
        }
    }
}
