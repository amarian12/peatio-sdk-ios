import Foundation

public final class AssetWhitelistAddressesOperation: RequestOperation {
    public typealias ResultData = [ViewerWhitelistAddress]

    public lazy private(set) var path: String = "/api/uc/v1/me/whitelist_addresses"

    public var requestParams: [String : Any] {
        return ["asset_uuids": param.assetPairUUIDs]
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension AssetWhitelistAddressesOperation {
    public struct Param: Equatable {

        public let assetPairUUIDs: [String]

        public init(assetPairUUIDs: [String]) {
            self.assetPairUUIDs = assetPairUUIDs
        }
    }
}
