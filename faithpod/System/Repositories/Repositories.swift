//
//  Repositories.swift
//  faithpod
//
//  Created by Ambrose Mbayi on 05/05/2025.
//


class Repositories {
    private var  repositories = [String: Repository]()
    
    func register<R: Repository> (_ repository: R) {
        repositories["\(R.self)"]  = repository
    }
    
    func resolve<R: Repository>(_ repositoryType: R.Type) -> R {
        guard let repository = repositories["\(R.self)"] as? R else {
            fatalError("Attempting to access a repository that hasn't been registered inside DependencyContainer")
        }
        
        return repository
    }
}
