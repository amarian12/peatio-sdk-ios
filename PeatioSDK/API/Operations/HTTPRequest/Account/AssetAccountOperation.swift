import Foundation

public final class AssetAccountOperation: RequestOperation {
    public typealias ResultData = [Account]

    public let path: String = "/api/xn/v1/me/accounts"

    public var requestParams: [String: Any]? {
        guard let assetUUIDs = param.assetUUIDs, !assetUUIDs.isEmpty else { return nil }
        return ["asset_ids": assetUUIDs]
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension AssetAccountOperation {
    public struct Param: Equatable {
        let assetUUIDs: [String]?

        public init(assetUUIDs: [String]?) {
            self.assetUUIDs = assetUUIDs
        }
    }
}
