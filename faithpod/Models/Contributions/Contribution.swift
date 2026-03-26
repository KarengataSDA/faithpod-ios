
struct ContributionItem: Codable {
    let userId: Int?
    let contributionTypeId: Int?
    let contributionAmount: Double?
    let contributionDate: String?
    let status: String?
}

struct Contribution {
    let contributions: [ContributionItem]?
}
