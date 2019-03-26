import Foundation

public final class CreateAssetWhitelistAddressOperation: RequestOperation {
    public typealias ResultData = ViewerWhitelistAddress

    public let path: String = "/api/uc/v1/me/whitelist_addresses"

    public let httpMethod: HTTPMethod = .post

    public var requestParams: [String: Any]? {
        var result = [
            "asset_uuid": param.assetUUID,
            "tag": param.tag,
            "address": param.address,
            "pin": param.pin,
            "otp_code": param.otp
        ]

        result["memo"] = param.memo
        return result
    }

    public let param: Param

    public init(param: Param) {
        self.param = param
    }
}

extension CreateAssetWhitelistAddressOperation {

    public struct Param: Equatable {
        public let assetUUID: String
        public let tag: String
        public let memo: String?
        public let address: String
        public let pin: String
        public let otp: String

        public init(assetUUID: String,
                    tag: String,
                    memo: String?,
                    address: String,
                    pin: String,
                    otp: String) {
            self.assetUUID = assetUUID
            self.tag = tag
            self.memo = memo
            self.address = address
            self.pin = pin
            self.otp = otp
        }
    }
}
