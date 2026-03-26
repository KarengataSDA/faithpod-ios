import Foundation

struct ContributionType: Codable, Hashable, Equatable, Identifiable {
    let id: Int?
    let name: String?
    let description: String?
    let archived: Bool
}

