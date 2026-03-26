import Foundation

struct PostSignInResponse: Decodable {
    let token: String
    let member: Member
}

struct Member: Decodable {
    let id: Int
    let full_name: String
    let email: String
    let roles: [String]
}
