import Foundation
import Combine

struct GetGroupsTask: TaskCombineNoninjectable {
    typealias RepositoryType = CustomerRepository
    typealias CombineResponse = [PopulationGroup]

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<CombineResponse, any Error> {
        return repository.getPopulationGroups()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
