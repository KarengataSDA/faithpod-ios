import Foundation

struct PostSignInResponse: Decodable {
    let token: String
    let refresh_token: String
    let expires_at: Int64
    let expires_in: Int64
    let user: User
}

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}
