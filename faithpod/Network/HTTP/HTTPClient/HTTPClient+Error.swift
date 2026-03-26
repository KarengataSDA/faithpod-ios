import Foundation

extension HTTPClient {
    enum HTTPClientError: LocalizedError {
        case unknown(statusCode: Int, data: Data)
        case invalidBaseUrl
        case invalidBody
        case message(statusCode: Int, response: HTTPErrorMessageResponse)
        case unauthorized
        case unauthorizedRetryable
        case networkError(String)
        case noInternetConnection
        case timeout
        case serverUnavailable

        var errorDescription: String? {
            switch self {
            case .unknown(let statusCode, _):
                return "Something went wrong. Please try again. (Error: \(statusCode))"
            case .invalidBaseUrl:
                return "Unable to connect to server. Please try again later."
            case .invalidBody:
                return "Invalid request. Please try again."
            case .message(_, let response):
                return response.message
            case .unauthorized:
                return "Session expired. Please log in again."
            case .unauthorizedRetryable:
                return "Session expired. Attempting to refresh..."
            case .networkError(let message):
                return message
            case .noInternetConnection:
                return "No internet connection. Please check your network and try again."
            case .timeout:
                return "Request timed out. Please try again."
            case .serverUnavailable:
                return "Server is currently unavailable. Please try again later."
            }
        }

        var failureReason: String? {
            switch self {
            case .unknown:
                return "Something Went Wrong"
            case .invalidBaseUrl, .serverUnavailable:
                return "Server Unavailable"
            case .invalidBody:
                return "Invalid Request"
            case .message:
                return "Error"
            case .unauthorized, .unauthorizedRetryable:
                return "Session Expired"
            case .networkError:
                return "Connection Error"
            case .noInternetConnection:
                return "No Internet Connection"
            case .timeout:
                return "Request Timed Out"
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .unknown(let statusCode, _):
                return "Please try again. (Error: \(statusCode))"
            case .invalidBaseUrl, .serverUnavailable:
                return "Please try again later."
            case .invalidBody:
                return "Please try again."
            case .message(_, let response):
                return response.message
            case .unauthorized:
                return "Please log in again."
            case .unauthorizedRetryable:
                return "Attempting to refresh your session..."
            case .networkError(let message):
                return message
            case .noInternetConnection:
                return "Please check your network and try again."
            case .timeout:
                return "Please try again."
            }
        }
    }

    static func mapURLError(_ error: URLError) -> HTTPClientError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternetConnection
        case .timedOut:
            return .timeout
        case .cannotConnectToHost, .cannotFindHost:
            return .serverUnavailable
        case .secureConnectionFailed:
            return .networkError("Secure connection failed. Please check your network and try again.")
        case .serverCertificateUntrusted, .serverCertificateHasBadDate, .serverCertificateNotYetValid, .serverCertificateHasUnknownRoot:
            return .networkError("Unable to establish a secure connection. Please try again later.")
        case .cancelled:
            return .networkError("Request was cancelled.")
        default:
            return .networkError("Connection error. Please check your network and try again.")
        }
    }
}
