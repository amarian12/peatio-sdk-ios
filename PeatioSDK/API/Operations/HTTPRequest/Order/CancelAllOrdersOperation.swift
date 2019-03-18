import Foundation

public final class CancelAllOrdersOperation: RequestOperation {
    public typealias ResultData = BatchCancelOrderResult

    public lazy private(set) var path: String = "/api/xn/v1/me/orders/cancel"

    public let httpMethod: HTTPMethod = .post

    public let requestParams: [String: Any]? = nil

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension CancelAllOrdersOperation {
    public struct Param: Equatable {

        public init() { }
    }
}
