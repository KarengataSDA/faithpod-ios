import Foundation
import Combine

struct ContributionTypeRepository: Repository {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getContributionTypes() -> AnyPublisher<[ContributionType], Error> {
        let request = ContributionTypeRequest()
        
        return client.perform(request).tryMap { response in
            let contributionTypes = response.map { ContributionType(response: $0) }
            //print("contributionTypes \(contributionTypes)")
            return contributionTypes
        }.eraseToAnyPublisher()
    }
    
}
