//
//  Tasks.swift
//  karengata
//
//  Created by Ambrose Mbayi on 05/05/2025.
//


struct Tasks {
    private let repositories: Repositories
    
    init(repositories: Repositories) {
        self.repositories = repositories
    }
    
    func initialize<T: Task>(_ type: T.Type) -> T {
        let repository = repositories.resolve(T.RepositoryType.self)
        return T(repository: repository)
    }
    
    func displayAlert(message: String, style: AlertStyle) {
        let taskModel = DisplayAlertMessageTask.Model(message: message.extractJSONError(), style: style)
        let task = initialize(DisplayAlertMessageTask.self)
        
        task.execute(with: taskModel)
    }
    
    func displayAlert(error: Error) -> Bool {
        guard let error = error as? HTTPClient.HTTPClientError else {
            return false
        }
        switch error {
        case .message(_, let messageError):
            displayAlert(message: messageError.message, style: .error)
            
            return true
            
        default:
            return false
        }
    }
}
