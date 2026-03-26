import Foundation
import Combine

struct TransactionStatusTask: TaskCombineNoninjectable {
    typealias RepositoryType = TransactionStatusRepository
    typealias CombineResponse = TransactionStatus
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<CombineResponse, any Error> {
        return repository.getTransctionStatus()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
