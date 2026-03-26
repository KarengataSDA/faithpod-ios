import Foundation

struct ContributionTypeResponse: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let archived: Bool
}
