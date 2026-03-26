import Foundation

struct PostSignInRequest: HTTPRequest, HTTPAuthenticationRequest {
    typealias Payload = PostSignInPayload
    typealias Response = PostSignInResponse

    init(payload: Payload) {
        body = payload
    }

    let path: HTTPEndpoint = KSDAEndpoint.customers_signin
    let method = HTTPMethod.POST
    var body: Payload?
}
