import Foundation

public final class FavoriteAssetPairsOperation: RequestOperation {
    public typealias ResultData = [AssetPair]

    public let path: String = "/api/xn/v1/me/fave_asset_pairs"

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension FavoriteAssetPairsOperation {
    public struct Param: Equatable {
        public init() { }
    }
}
