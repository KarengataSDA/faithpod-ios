import Foundation
import Combine

struct GetContributionsTask: TaskCombineNoninjectable {
    typealias RepositoryType = CustomerRepository
    typealias CombineResponse = [ContributionHistory]
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<CombineResponse, Error> {
        return repository.getCustomerContributions()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
