import Foundation

struct PostForgotPasswordRequest: HTTPRequest, HTTPAuthenticationRequest {
    typealias Payload = PostForgotPasswordPayload
    typealias Response = PostForgotPasswordResponse

    init(payload: Payload) {
        body = payload
    }

    let path: HTTPEndpoint = KSDAEndpoint.password_email
    let method = HTTPMethod.POST
    var body: Payload?
}
