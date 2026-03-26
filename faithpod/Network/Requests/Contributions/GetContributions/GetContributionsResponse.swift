import Foundation


struct GetContributionsResponse: Decodable {
    let contributions: [ContributionHistoryResponse]
}

struct ContributionHistoryResponse: Decodable {
    let id: Int
    let user_id: Int
    let member_id: Int
    let contributiontype_id: Int
    let contribution_amount: Double
    let contribution_date: String
    let status: String
    let email_sent: Int
    let sms_sent: Int
    let contribution_type: ContributionType
}
