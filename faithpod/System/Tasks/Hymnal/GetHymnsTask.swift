import Foundation
import Combine

struct GetHymnsTask: TaskCombineNoninjectable {
    typealias RepositoryType = HymnalRepository
    typealias CombineResponse = [Hymn]

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<CombineResponse, Error> {
        return repository.getHymns()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct GetHymnLanguagesTask: TaskCombineNoninjectable {
    typealias RepositoryType = HymnalRepository
    typealias CombineResponse = [HymnalLanguage]

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<CombineResponse, Error> {
        return repository.getLanguages()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct GetHymnFavoritesTask: TaskCombineNoninjectable {
    typealias RepositoryType = HymnalRepository
    typealias CombineResponse = [Hymn]

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<CombineResponse, Error> {
        return repository.getFavorites()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct ToggleHymnFavoriteTask: TaskCombineInjectable {
    typealias RepositoryType = HymnalRepository
    typealias CombineResponse = Bool
    typealias Model = Int

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute(with hymnId: Model) -> AnyPublisher<CombineResponse, Error> {
        return repository.toggleFavorite(hymnId: hymnId)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
