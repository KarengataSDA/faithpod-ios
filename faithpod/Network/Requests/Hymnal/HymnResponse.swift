import Foundation

struct HymnResponse: Decodable {
    let id: Int
    let hymnNumber: Int
    let title: String
    let author: String?
    let lyrics: String
    let language: HymnLanguageResponse
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case hymnNumber = "hymn_number"
        case title
        case author
        case lyrics
        case language
        case isFavorite = "is_favorite"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        hymnNumber = try container.decode(Int.self, forKey: .hymnNumber)
        title = try container.decode(String.self, forKey: .title)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        lyrics = try container.decode(String.self, forKey: .lyrics)
        language = try container.decode(HymnLanguageResponse.self, forKey: .language)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}

struct HymnLanguageResponse: Decodable {
    let id: Int
    let name: String
    let description: String
    let isActive: Bool
    let hymnsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case isActive = "is_active"
        case hymnsCount = "hymns_count"
    }
}
