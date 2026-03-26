import Foundation
import Combine

struct ForgotPasswordTask: TaskCombineInjectable {
    typealias RepositoryType = CustomerRepository
    typealias Model = ForgotPasswordTaskModel
    typealias CombineResponse = PostForgotPasswordResponse

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute(with object: Model) -> AnyPublisher<CombineResponse, any Error> {
        return repository.forgotPassword(email: object.email)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
