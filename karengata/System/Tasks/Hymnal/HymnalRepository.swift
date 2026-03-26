import Foundation
import Combine

struct HymnalRepository: Repository {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func getHymns() -> AnyPublisher<[Hymn], Error> {
        let request = GetHymnsRequest()

        return client.perform(request)
            .tryMap { response in
                response.map { Hymn(response: $0) }
            }
            .eraseToAnyPublisher()
    }

    func getLanguages() -> AnyPublisher<[HymnalLanguage], Error> {
        let request = GetHymnLanguagesRequest()

        return client.perform(request)
            .tryMap { response in
                response.map { HymnalLanguage(response: $0) }
            }
            .eraseToAnyPublisher()
    }

    func getFavorites() -> AnyPublisher<[Hymn], Error> {
        let request = GetHymnFavoritesRequest()

        return client.perform(request)
            .tryMap { response in
                response.map { Hymn(response: $0) }
            }
            .eraseToAnyPublisher()
    }

    func toggleFavorite(hymnId: Int) -> AnyPublisher<Bool, Error> {
        let request = ToggleHymnFavoriteRequest(hymnId: hymnId)

        return client.perform(request)
            .map { response in
                response.isFavorite
            }
            .eraseToAnyPublisher()
    }
}
