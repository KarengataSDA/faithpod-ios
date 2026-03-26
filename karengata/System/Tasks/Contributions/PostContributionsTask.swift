import Foundation
import Combine

struct PostContributionsTask: TaskCombineInjectable {
    typealias RepositoryType = ContributionsRepository
    typealias Model = ContributionsTaskModel
    typealias CombineResponse = Contribution
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute(with object: Model) -> AnyPublisher<CombineResponse, any Error> {
        return repository.postContributions(with: object)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
