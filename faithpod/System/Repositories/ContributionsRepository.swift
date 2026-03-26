import Foundation
import Combine

struct ContributionsRepository: Repository {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func postContributions(with taskModel: PostContributionsTask.Model) -> AnyPublisher<Contribution, Error> {
        let payload = ContributionsRequest.Payload(taskModel: taskModel)
        let request = ContributionsRequest(payload: payload)
        
        return client.perform(request)
            .receive(on: DispatchQueue.main)
            .tryMap { response in
               let contributions = Contribution(response: response)
               return contributions
            
        }.eraseToAnyPublisher()
    }
}
