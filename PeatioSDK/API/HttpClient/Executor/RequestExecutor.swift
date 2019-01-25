import Foundation
import Result

let requestDecoder: JSONDecoder = {
    let result = JSONDecoder()
    result.dateDecodingStrategy = .iso8601
    result.keyDecodingStrategy = .convertFromSnakeCase
    return result
}()

open class RequestExecutor: HTTPRequestExecutor {

    public var accetpLanguge: String? {
        didSet {
            additionalHeaders["Accept-Language"] = accetpLanguge
        }
    }

    public var additionalHeaders: [String: String] = [:]

    public private(set) var endpoint: URL

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()

    private(set) var tokenValue: String? {
        didSet {
            additionalHeaders["Authorization"] = tokenValue
        }
    }

    deinit {
        session.invalidateAndCancel()
    }

    public init(endpoint: URL) {
        self.endpoint = endpoint
    }

    func setToken(token: PeatioToken?) {
        guard let token = token else {
            self.tokenValue = nil
            return
        }
        self.tokenValue = "Bearer " + token.jwtValue
    }

    @discardableResult
    public func request<O>(_ operation: O, debug: Bool = false, completion: @escaping (Result<O.ResultData, PeatioSDKError>) -> Void) -> APIRequestTask where O: RequestOperation {
        var additionalHeaders: [String: String] = [:]

        additionalHeaders["Accept-Language"] = accetpLanguge
        additionalHeaders["Authorization"] = tokenValue

        guard let expectRequest = try? RequestGenerator.buildRequest(baseURL: endpoint, operation: operation, additionalHeaders: additionalHeaders) else { fatalError() }

        let task = session.dataTask(with: expectRequest) { (data, response, error) in
            let blockResult = RequestExecutor.buildResult(operation: operation, data: data, error: error, response: response)
            DispatchQueue.main.async {
                if PeatioSDK.debug {
                    let header = "\t=========== Execution Finished ================\n\n\n\t"
                    let subT1 = "Request Infomation ================\n\t"
                    let requestInfo = expectRequest.peatio_cURLString
                    let subT2 = "\n\n\t=========== Request Result ================\n\t"
                    let resultInfo: String
                    switch blockResult {
                    case .success(let value):
                        resultInfo = "\n\tValue: {\n\n\t\(value)\n\n\t}\n"
                    case .failure(let error):
                        resultInfo = "\n\tFailure: {\n\n\t\t\(error.localizedDescription)\n\n\t}\n"
                    }
                    let tail = "\t=========== Execution Finished ================\n\t"
                    Log.debug(header + subT1 + requestInfo + subT2 + resultInfo + tail)
                }
                completion(blockResult)
            }
        }

        task.resume()

        let requestTask = APIRequestTask(method: operation.httpMethod,
                                         url: expectRequest.url!,
                                         path: operation.path,
                                         parameters: operation.requestParams,
                                         sessionTask: task)

        return requestTask
    }

    public static func buildResult<O>(operation: O, data: Data?, error: Error?, response: URLResponse?) -> Result<O.ResultData, PeatioSDKError> where O: RequestOperation {
        guard let httpResponse = response as? HTTPURLResponse else {
            guard let error = error else {
                fatalError("invalid response")
            }
            return .failure(.network(error))
        }

        guard let data = data else {
            if let error = error {
                return .failure(.network(error))
            } else {
                let invalidResponse = APIError.invalid(httpResponse, supplement: "no data")
                return .failure(.api(invalidResponse))
            }
        }

        if let decodeInjection = operation.decodeInjection, let object = decodeInjection(data) {
            return .success(object)
        }

        var grainedResult: RequestOperationResult<O.ResultData>
        do {
            grainedResult = try requestDecoder.decode(RequestOperationResult<O.ResultData>.self, from: data)
        } catch let e {
            var detail: String = e.localizedDescription
            if let decodingError = e as? DecodingError {
                detail = decodingError.peatio_debugDescription
            }
            let invalidResponse = APIError.invalid(httpResponse, supplement: "Grained deserialization failed, detail: \(detail)")
            return .failure(.api(invalidResponse))
        }

        guard grainedResult.isSuccessful else {
            let supplement = grainedResult.decodeDataError?.peatio_debugDescription ?? "null"
            let error = APIError(code: grainedResult.code, message: grainedResult.message + "  ,supplement: \(supplement)", response: httpResponse, data: data)
            return .failure(.api(error))
        }

        if let object = grainedResult.data {
            return .success(object)
        } else {
            guard let deErrorr = grainedResult.decodeDataError else {
                do {
                    let innerRetry = try requestDecoder.decode(O.ResultData.self, from: data)
                    return .success(innerRetry)
                } catch let e {
                    let deserializedError = APIError.deserializeFailed(httpResponse,
                                                                       message: "Deserializing \(O.ResultData.self) failed, detail: \(e.peatio_debugDescription)", data: data)
                    return .failure(.api(deserializedError))
                }
            }
            let deserializedError = APIError.deserializeFailed(httpResponse,
                                                               message: "Deserializing \(O.ResultData.self) failed, detail: \(deErrorr.peatio_debugDescription)", data: data)
            return .failure(.api(deserializedError))
        }
    }
}
