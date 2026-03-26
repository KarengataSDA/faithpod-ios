import Foundation

struct ContributionsPayload: Codable {
    struct Item: Codable {
        let user_id: Int?
        let contributiontype_id: Int?
        let contribution_amount: Double?
        let contribution_date: String?
        let status: String?
    }
    
    let contributions: [Item]?
}
