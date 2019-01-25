import Foundation

public final class CreateSessionBySSOOperation: RequestOperation {
    public typealias ResultData = PeatioToken

    public let path: String = "/api/uc/v1/session/sso"

    public let httpMethod: HTTPMethod = .post

    public var requestParams: [String: Any]? {
        return [
            "authentication_request": [
                "token": param.exchangeToken
            ]
        ]
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension CreateSessionBySSOOperation {
    public struct Param: Equatable {

        public let exchangeToken: String

        public init(exchangeToken: String) {
            self.exchangeToken = exchangeToken
        }
    }
}
