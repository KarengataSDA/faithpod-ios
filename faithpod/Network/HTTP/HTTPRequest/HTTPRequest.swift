import Foundation

protocol HTTPRequest {
    associatedtype Payload: Encodable
    associatedtype Response: Decodable

    var method: HTTPMethod { get }
    var path: HTTPEndpoint { get }
    var body: Payload? { get }
}

/// Marker protocol for authentication requests (login, signup, etc.)
/// 401 errors on these requests should NOT trigger session expiration handling
protocol HTTPAuthenticationRequest: HTTPRequest {}
