import Foundation
import Combine

struct GetPrayerCellsTask: TaskCombineNoninjectable {
    typealias RepositoryType = CustomerRepository
    typealias CombineResponse = [PrayerCell]

    private let repository: RepositoryType

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<CombineResponse, any Error> {
        return repository.getPrayerCells()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
