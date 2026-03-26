import Foundation
import Combine

struct SignInTask: TaskCombineInjectable {
    typealias RepositoryType = CustomerRepository
    typealias Model = SignInTaskModel
    typealias CombineResponse = PostSignInResponse
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute(with object: Model) -> AnyPublisher<CombineResponse, any Error> {
        return repository.authenticate(with: object)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
