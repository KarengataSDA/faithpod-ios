import Foundation
import Combine

protocol NetworkClient {
    func perform<Request: HTTPRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error>
}

private class NoRedirectSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

class HTTPClient: NetworkClient {
    private static let badRequestStatusCode = 400
    private static let unauthorizedStatusCode = 401

    private let context: HTTPMessageContextual
    private let session: URLSession
    private let sessionManager: SessionManaging?

    private let encoder = HTTPClientEncoder()
    private let decoder = HTTPClientDecoder()

    init(context: HTTPMessageContextual, session: URLSession = URLSession(configuration: .default, delegate: NoRedirectSessionDelegate(), delegateQueue: nil), sessionManager: SessionManaging? = nil) {
        self.context = context
        self.session = session
        self.sessionManager = sessionManager
    }

    func perform<Request: HTTPRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        guard let url = getValidRequestURL(for: request) else {
            return Fail(error: HTTPClientError.invalidBaseUrl).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = getRequestHeaders(for: request)

        if let httpBody = request.body {
            do {
                urlRequest.httpBody = try encoder.encode(httpBody)
            } catch {
                return Fail(error: HTTPClientError.invalidBody).eraseToAnyPublisher()
            }
        }

        cancelDuplicateRequest(for: urlRequest)

        urlRequest.cUrlLogDebug()

        // Skip session expiration handling for authentication requests (login, signup, etc.)
        let isAuthRequest = request is any HTTPAuthenticationRequest

        if isAuthRequest {
            return execute(urlRequest, unauthorizedBehavior: .returnError)
                .decode(type: Request.Response.self, decoder: decoder)
                .eraseToAnyPublisher()
        }

        // For regular requests: on 401, attempt refresh then retry
        return execute(urlRequest, unauthorizedBehavior: .attemptRefresh)
            .tryCatch { [weak self] (error: Error) -> AnyPublisher<Data, Error> in
                guard let self = self,
                      let clientError = error as? HTTPClientError,
                      case .unauthorizedRetryable = clientError else {
                    throw error
                }

                print("🔄 HTTPClient: 401 received, attempting token refresh before retry")
                guard let sessionManager = self.sessionManager else {
                    throw HTTPClientError.unauthorized
                }

                return sessionManager.attemptTokenRefresh()
                    .setFailureType(to: Error.self)
                    .flatMap { success -> AnyPublisher<Data, Error> in
                        guard success else {
                            print("🔴 HTTPClient: refresh failed")
                            return Fail(error: HTTPClientError.unauthorized).eraseToAnyPublisher()
                        }

                        print("✅ HTTPClient: refresh succeeded, retrying original request")
                        // Rebuild the request with fresh headers
                        var retryRequest = urlRequest
                        retryRequest.allHTTPHeaderFields = self.getRequestHeaders(for: request)
                        return self.execute(retryRequest, unauthorizedBehavior: .handleUnauthorized)
                    }
                    .eraseToAnyPublisher()
            }
            .decode(type: Request.Response.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    /// Perform a request without 401 interception (used for refresh token calls)
    func performWithoutInterception<Request: HTTPRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        guard let url = getValidRequestURL(for: request) else {
            return Fail(error: HTTPClientError.invalidBaseUrl).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = getRequestHeaders(for: request)

        if let httpBody = request.body {
            do {
                urlRequest.httpBody = try encoder.encode(httpBody)
            } catch {
                return Fail(error: HTTPClientError.invalidBody).eraseToAnyPublisher()
            }
        }

        urlRequest.cUrlLogDebug()

        return execute(urlRequest, unauthorizedBehavior: .returnError)
            .decode(type: Request.Response.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    private enum UnauthorizedBehavior {
        case returnError          // Return error without session handling (auth requests, refresh calls)
        case attemptRefresh       // Signal retryable 401 so caller can refresh and retry
        case handleUnauthorized   // Immediately call handleUnauthorized (retry after refresh failed)
    }

    private func execute(_ request: URLRequest, unauthorizedBehavior: UnauthorizedBehavior) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: request)
            .mapError { urlError -> Error in
                return HTTPClient.mapURLError(urlError)
            }
            .tryMap { [weak self] (data, response) -> Data in
                guard let self = self, let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPClientError.unknown(statusCode: HTTPClient.badRequestStatusCode, data: data)
                }

                let statusCode = httpResponse.statusCode
                print("HTTPClient: received status code \(statusCode)")

                // Handle token expiry (401 Unauthorized)
                if statusCode == HTTPClient.unauthorizedStatusCode {
                    switch unauthorizedBehavior {
                    case .returnError:
                        print("HTTPClient: 401 on auth/refresh request - returning error without session handling")
                        throw self.errorInfo(from: data, statusCode: statusCode)
                    case .attemptRefresh:
                        print("HTTPClient: 401 - will attempt token refresh")
                        throw HTTPClientError.unauthorizedRetryable
                    case .handleUnauthorized:
                        print("HTTPClient: 401 after retry - calling handleUnauthorized")
                        self.sessionManager?.handleUnauthorized()
                        throw HTTPClientError.unauthorized
                    }
                }

                guard 200..<300 ~= statusCode else {
                    throw self.errorInfo(from: data, statusCode: statusCode)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}


extension HTTPClient {
    private func getValidRequestURL<Request: HTTPRequest>(for request: Request) -> URL? {
        var components = URLComponents()
        components.path = request.path.endpoint

        let baseUrl = context.hostUrl
        return components.url(relativeTo: baseUrl)
    }

    // to be worked on
    private func errorInfo(from data: Data, statusCode: Int) -> Error {
        if let errorResponse = try? self.decoder.decode(HTTPErrorMessageResponse.self, from: data) {
            return HTTPClientError.message(statusCode: statusCode, response: errorResponse)
        }

        if let message = String(data: data, encoding: .utf8) {
            if(self.isHtmlString(message)) {
                return HTTPClientError.unknown(statusCode: statusCode, data: data)
            }

            let errorResponse = HTTPErrorMessageResponse(message: message)
            return HTTPClientError.message(statusCode: statusCode, response: errorResponse)
        }

        return HTTPClientError.unknown(statusCode: statusCode, data: data)
    }


    func getRequestHeaders<Request: HTTPRequest>(for request: Request) -> [String: String] {
        var headers: [String: String]  = context.headers
        if let requestHeaders = (request as? HTTPRequestHeaders)?.headers {
            headers = headers.merging(requestHeaders, uniquingKeysWith: {(_, new) in new})
        }
        return headers
    }

    private func cancelDuplicateRequest(for urlRequest: URLRequest) {
        session.getAllTasks { tasks in
            if let task = tasks.first(where: {
                $0.originalRequest?.url == urlRequest.url &&
                $0.originalRequest?.httpMethod == urlRequest.httpMethod
            }) {
                task.cancel()
            }
        }
    }

    func isHtmlString(_ value: String) -> Bool {
        if value.isEmpty {
            return false
        }

        return (value.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }
}
