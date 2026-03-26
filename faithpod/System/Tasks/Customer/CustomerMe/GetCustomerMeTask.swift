import Foundation
import Combine

struct GetCustomerMeTask: TaskCombineNoninjectable {
    typealias RepositoryType = CustomerRepository
    typealias CombineResponse = Bool
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Bool, any Error> {
        return repository.getCustomerMe()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
