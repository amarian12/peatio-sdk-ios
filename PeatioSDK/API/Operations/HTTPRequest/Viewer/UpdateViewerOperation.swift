import Foundation

public final class UpdateViewerOperation: RequestOperation {
    public typealias ResultData = JustOK

    public let path: String = "/api/uc/v1/me/profile"

    public let httpMethod: HTTPMethod = .patch

    public var requestParams: [String: Any]? {
        return ["locale": param.locale]
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension UpdateViewerOperation {
    public struct Param: Equatable {

        public let locale: String

        public init(locale: String) {
            self.locale = locale
        }
    }
}
