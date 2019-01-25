import Foundation

public final class ViewerOrdersOperation: RequestOperation {
    public typealias ResultData = Page<Order>

    public let path: String = "/api/xn/v1/me/orders"

    public var requestParams: [String: Any]? {
        var box: [String: Any] = [
            "limit": param.limit,
            "type": param.type.rawValue,
            "state": param.state.rawValue
        ]

        box["asset_pair_uuid"] = param.assetPairUUID
        box["page_token"] = param.pageToken
        return box
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension ViewerOrdersOperation {
    public struct Param: Equatable {

        public let assetPairUUID: String?
        public let limit: Int
        public let state: Order.State
        public let pageToken: String?
        public let type: OrderType

        public init(assetPairUUID: String?,
                    limit: Int,
                    state: Order.State,
                    pageToken: String?,
                    type: OrderType = .limit) {
            self.assetPairUUID = assetPairUUID
            self.limit = limit
            self.state = state
            self.pageToken = pageToken
            self.type = type
        }
    }
}
