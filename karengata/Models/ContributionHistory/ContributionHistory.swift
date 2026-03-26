import Foundation

struct ContributionHistory: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let contributiontypeId: Int
    let contributionAmount: Double
    let contributionDate: String
    let status: String
    let emailSent: Int
    let smsSent: Int
    let contributionType: ContributionType
}
