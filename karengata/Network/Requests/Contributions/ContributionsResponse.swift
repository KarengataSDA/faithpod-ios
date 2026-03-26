struct ContributionResponse: Codable {
    let user_id: Int?
    let contributiontype_id: Int?
    let contribution_amount: Double?
    let contribution_date: String?
    let status: String?
}

struct PostContributionsResponse: Codable {
    let contributions: [ContributionResponse]?
}

