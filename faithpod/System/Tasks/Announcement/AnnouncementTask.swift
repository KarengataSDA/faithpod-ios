import Foundation
import Combine

struct AnnouncementTask: TaskCombineNoninjectable {
    typealias RepositoryType = AnnouncementRepository
    typealias CombineResponse = [Announcement]
    
    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<CombineResponse,  Error> {
        return repository.getAnnouncements()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

