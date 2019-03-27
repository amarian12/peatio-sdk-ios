import Foundation

public enum PeatioAPI {

    static var apiScheme = "http"
    static var wsScheme = "ws"

    public static var host: String? {
        didSet {
            reset()
        }
    }

    public static var accetpLanguge: String? {
        didSet {
            _req.accetpLanguge = accetpLanguge
        }
    }

    public static var observer: WebSocketObserver {
        guard let observer = _ws else {
            fatalError("Plesase class 'PeatioSDK.start(host:)' to set correct host")
        }
        return observer
    }

    public static var executor: RequestExecutor {
        guard let executor = _req else {
            fatalError("Plesase class 'PeatioSDK.start(host:)' to set correct host")
        }
        return executor
    }

    static var _ws: InnerWebSocketObserver!
    static var _req: RequestExecutor!
}

extension PeatioAPI {
    static func reset() {
        guard let host = host,
            let apiEndpoint = URL(string: "\(apiScheme)://\(host)"),
            let wsEndpoint = URL(string: "\(wsScheme)://\(host)/ws/v2")
            else {
                fatalError("Plesase set correct host")
        }
        _ws = InnerWebSocketObserver(endpoint: wsEndpoint)
        _req = RequestExecutor(endpoint: apiEndpoint)
        _req.accetpLanguge = accetpLanguge
    }

    static func setToken(_ token: PeatioToken?) {
        _ws.setToken(token: token)
        _req.setToken(token: token)
    }
}

// MARK: - HTTP Request
public extension PeatioAPI {
    static func execute<O>(_ operation: O, deubg: Bool = false, completion: @escaping (Result<O.ResultData, PeatioSDKError>) -> Void) -> APIRequestTask where O: RequestOperation {
        return executor.request(operation, debug: deubg, completion: completion)
    }
}

// MARK: - WebSocket Request
public extension PeatioAPI {

    static func subscribe<O>(_ operation: O, onReceive: @escaping (WebSocketEvent<O>) -> Void) -> WebSocketTask where O: SubscriptionOperation {
        return observer.subscribe(operation, onReceive: onReceive)
    }
}
