import Foundation

struct PostRefreshTokenResponse: Decodable {
    let token: String
    let refresh_token: String
    let expires_at: Int64
    let expires_in: Int64
    let user: User
}
