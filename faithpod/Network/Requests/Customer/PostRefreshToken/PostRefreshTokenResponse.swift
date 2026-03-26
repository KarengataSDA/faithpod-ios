import Foundation

struct PostRefreshTokenResponse: Decodable {
    let token: String
    let member: Member
}
