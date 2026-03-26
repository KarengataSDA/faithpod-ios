import SwiftUI
import Combine

class TransactionHistoryViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var transactionHistory: [ContributionHistory] = []
    
    init() {
        getTransactionsHistory()
    }

    func getTransactionsHistory() {
        isLoading = true
        
        let task = tasks.initialize(GetContributionsTask.self)
        
        return task.execute()
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { response in
                self.isLoading = false
                switch response {
                case .finished:
                    break
                case .failure(let error):
                  self.error = error
                    break
                }
            }, receiveValue: { items  in
                self.transactionHistory = items
            }))
    }
}
