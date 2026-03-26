import Foundation
import Combine

struct ContributionsTypeTask: TaskCombineNoninjectable {
    typealias RepositoryType = ContributionTypeRepository
    typealias CombineResponse = [ContributionType]
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<CombineResponse, Error> {
        return repository.getContributionTypes()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
