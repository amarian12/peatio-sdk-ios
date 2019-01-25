import Foundation

public final class ViewerCustomerOperation: RequestOperation {
    public typealias ResultData = Customer

    public let path: String = "/api/uc/v1/me/profile"

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension ViewerCustomerOperation {
    public struct Param: Equatable {
        public init() { }
    }
}
