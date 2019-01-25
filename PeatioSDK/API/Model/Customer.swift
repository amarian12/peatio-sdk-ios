import Foundation

public struct Customer: Codable {

    public enum VerificationState: String, Codable {
        case initial
        case emailVerified = "email_verified"
        case identitySubmitted = "identity_submitted"
        case identityDenied = "identity_denied"
        case identityApproved = "identity_approved"
    }

    public let id: Int
    public let email: String
    public var mobile: String?
    public let userId: Int
    public let name: String
    public let locale: String
    public let securityLevel: Int
    public let verificationState: VerificationState
    public let twoFactorEnabled: Bool
    public let assetPinEnabled: Bool
    public let isWithdrawalEnabled: Bool
}
