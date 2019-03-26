import Foundation

public final class AssetWhitelistAddressesOperation: RequestOperation {
    public typealias ResultData = [ViewerWhitelistAddress]

    public lazy private(set) var path: String = "/api/uc/v1/me/whitelist_addresses?asset_uuids=\(param.assetUUIDs.joined(separator: ","))"

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension AssetWhitelistAddressesOperation {
    public struct Param: Equatable {

        public let assetUUIDs: [String]

        public init(assetUUIDs: [String]) {
            self.assetUUIDs = assetUUIDs
        }
    }
}
