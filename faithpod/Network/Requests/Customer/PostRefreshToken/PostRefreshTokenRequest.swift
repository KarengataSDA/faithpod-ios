import Foundation

struct PostRefreshTokenPayload: Encodable {
    let refresh_token: String
}

struct PostRefreshTokenRequest: HTTPRequest {
    typealias Payload = PostRefreshTokenPayload
    typealias Response = PostRefreshTokenResponse

    init(refreshToken: String) {
        body = PostRefreshTokenPayload(refresh_token: refreshToken)
    }

    let path: HTTPEndpoint = FaithpodEndpoint.token_refresh
    let method = HTTPMethod.POST
    var body: Payload?
}
