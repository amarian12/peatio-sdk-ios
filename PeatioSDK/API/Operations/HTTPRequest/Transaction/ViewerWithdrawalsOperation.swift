import Foundation

public final class ViewerWithdrawalsOperation: RequestOperation {
    public typealias ResultData = Page<WithdrawalItem>

    public var path: String = "/api/uc/v1/me/withdrawals"

    public var requestParams: [String: Any]? {
        var box: [String: Any] = [
            "limit": param.limit,
            "kinds": param.kinds.map { $0.rawValue }
        ]

        box["asset_uuid"] = param.assetUUID
        box["page_token"] = param.pageToken
        return box
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension ViewerWithdrawalsOperation {
    public struct Param: Equatable {

        public enum Kind: String, Codable {
            case `internal` = "INTERNAL"
            case offChain = "OFF_CHAIN"
            case onChain = "ON_CHAIN"
        }

        public let assetUUID: String?
        public let limit: Int
        public let kinds: [Param.Kind] = [.internal, .offChain, .onChain]
        public let pageToken: String?

        public init(assetUUID: String?,
                    limit: Int,
                    pageToken: String?) {
            self.assetUUID = assetUUID
            self.limit = limit
            self.pageToken = pageToken
        }
    }
}
