import Foundation

public struct WhitelistAddress: Codable {
    let id: Int
    let assetUUID: String
    let tag: String
    let memo: String?
    let address: String
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case assetUUID = "assetUuid"
        case tag
        case memo
        case address
        case createdAt
    }
}
