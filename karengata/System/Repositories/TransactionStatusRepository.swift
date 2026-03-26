import Combine
struct TransactionStatusRepository: Repository {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    func getTransctionStatus() -> AnyPublisher<TransactionStatus, Error> {
        let request = TransactionStatusRequest()
        
        return client.perform(request).tryMap { response in
            let transactionStatus = TransactionStatus(response: response)
            print("the transactions are \(transactionStatus)")
            return transactionStatus
        }.eraseToAnyPublisher()
    }
    
}


