import Foundation
import Combine

struct ClearAlertsTask: TaskNoninjectable {
    typealias RepositoryType = AlertRepository
    
    private let repository: RepositoryType
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() {
        repository.clearAlerts()
    }
}
