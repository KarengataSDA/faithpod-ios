import Foundation
import Combine

struct UpdateCustomerTask: TaskCombineInjectable {
    typealias RepositoryType = CustomerRepository
    typealias Model = UpdateCustomerTaskModel
    typealias CombineResponse = Customer
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute(with object: Model) -> AnyPublisher<CombineResponse, any Error> {
        return repository.updateCustomer(with: object)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
