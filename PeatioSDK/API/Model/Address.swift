import Foundation

public struct Address: Codable {
    public let chain: String
    public let id: Int
    public let insertedAt: Date
    public let memo: String?
    public let value: String
}
