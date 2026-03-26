import Foundation

struct SignOutTask: TaskNoninjectable {
    typealias RepositoryType = CustomerRepository
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() {
        repository.signOut()
    }
}
