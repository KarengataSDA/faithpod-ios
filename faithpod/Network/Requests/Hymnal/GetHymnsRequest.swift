import Foundation

struct GetHymnsRequest: HTTPRequest {
    typealias Payload = EmptyPayload
    typealias Response = [HymnResponse]

    let path: HTTPEndpoint = KSDAEndpoint.hymns
    let method = HTTPMethod.GET
    var body: Payload?
}

struct GetHymnLanguagesRequest: HTTPRequest {
    typealias Payload = EmptyPayload
    typealias Response = [HymnLanguageResponse]

    let path: HTTPEndpoint = KSDAEndpoint.hymnLanguages
    let method = HTTPMethod.GET
    var body: Payload?
}

struct GetHymnFavoritesRequest: HTTPRequest {
    typealias Payload = EmptyPayload
    typealias Response = [HymnResponse]

    let path: HTTPEndpoint = KSDAEndpoint.hymnFavorites
    let method = HTTPMethod.GET
    var body: Payload?
}

struct ToggleHymnFavoriteRequest: HTTPRequest {
    typealias Payload = EmptyPayload
    typealias Response = ToggleFavoriteResponse

    let path: HTTPEndpoint
    let method = HTTPMethod.POST
    var body: Payload?

    init(hymnId: Int) {
        self.path = KSDAEndpoint.toggleHymnFavorite(hymnId: hymnId)
    }
}

struct ToggleFavoriteResponse: Decodable {
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case isFavorite = "is_favorite"
    }
}

struct EmptyPayload: Encodable {}
