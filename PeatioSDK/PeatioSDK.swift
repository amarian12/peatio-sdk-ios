import Foundation

public final class PeatioSDK {

    public static var debug = false

    static public func start(host: String) {
        PeatioAPI.host = host
    }

    static public func setToken(_ token: PeatioToken?) {
        PeatioAPI.setToken(token)
    }
}
