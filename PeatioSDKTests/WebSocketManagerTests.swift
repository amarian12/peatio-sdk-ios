import XCTest
@testable import PeatioSDK

class WebSocketManagerTests: XCTestCase {

    private let assetPairName = "BTC-USDT"
    let wsClient = InnerWebSocketObserver(endpoint: URL(string: "wss://b1.run/ws/v2")!)

    override func tearDown() {
        wsClient.reset()
    }

    func testSubscribeTrade() {
        let expectation1 = XCTestExpectation(description: "onSnapshot")
        let operation = TradeSubscription { .init(assetPair: assetPairName, limit: 25) }

        wsClient.subscribe(operation) { (event) in
            switch event {
            case .snapshot(let snp):
                Log.debug("receive trade snapshot, count: \(snp.count)")
                expectation1.fulfill()
            case .update:
                Log.debug("receive trade update")
            case .error(let error, _):
                Log.error("trade subscription error: \(error.localizedDescription)")
            }
        }

        wait(for: [expectation1], timeout: 5)
    }

    func testSubscribeCandlestick() {
        let expectation1 = XCTestExpectation(description: "onSnapshot")
        let expectation2 = XCTestExpectation(description: "onUpdate")

        let operation = CandleSubscription { .init(assetPair: assetPairName, limit: 10, period: .min1) }

        wsClient.subscribe(operation) { (event) in
            switch event {
            case .snapshot(let snp):
                Log.debug("receive candle snapshot, count: \(snp.count)")
                expectation1.fulfill()
            case .update:
                Log.debug("receive candle update")
                expectation2.fulfill()
            case .error(let error, _):
                Log.error("candle subscription error: \(error.localizedDescription)")
                fatalError()
            }
        }

        wait(for: [expectation1], timeout: 5)
        wait(for: [expectation2], timeout: 80)
    }

    func testSubscribeDepth() {
        let expectation1 = XCTestExpectation(description: "onSnapshot")

        let operation = DepthSubscription { .init(assetPair: assetPairName) }

        wsClient.subscribe(operation) { (event) in
            switch event {
            case .snapshot:
                Log.debug("receive depth snapshot")
                expectation1.fulfill()
            case .update:
                Log.debug("receive depth update")
            case .error(let error, _):
                Log.error("depth subscription error: \(error.localizedDescription)")
                fatalError()
            }
        }

        wait(for: [expectation1], timeout: 5)
    }

    func testViewerAccountSubscription() {
        let expectation = XCTestExpectation(description: "invalid token")
        let token = FakeToken.fakeToken(customerID: 30)

        wsClient.disconnect()
        wsClient.setToken(token: token)
        wsClient.connect()

        let operation = ViewerAccountSubscription { .init() }

        wsClient.subscribe(operation) { (event) in
            print(event)
            switch event {
            case .error(let ea, _):
                Log.error(ea)
                XCTAssertEqual(ea.code, PeatioError.unauthenticated.code)
                expectation.fulfill()
            case .snapshot(let snp):
                print(snp)
            case .update(let u):
                print(u)
            }
        }

        wait(for: [expectation], timeout: 10)
    }
}
