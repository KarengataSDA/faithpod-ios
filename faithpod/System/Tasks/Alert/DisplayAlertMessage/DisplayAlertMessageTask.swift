import Foundation
import Combine

struct DisplayAlertMessageTask: TaskInjectable {
    typealias Model = DisplayAlertMessageTaskModel
    typealias RepositoryType = AlertRepository
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute(with object: Model) {
        repository.storeAlertMessage(taskModel: object)
    }
}
