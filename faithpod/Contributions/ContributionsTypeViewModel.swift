import SwiftUI
import Combine

class ContributionsTypeViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var contributionTypes: [ContributionType] = []
    
    @Published var contributionAmounts:[String: String] = [:]
    
    init(){
       getContributionType()
    }
    
    var sortedContributionTypes: [ContributionType] {
        contributionTypes.sorted {
            ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending
        }
    }
    
    func resetContributions() {
        for key in contributionAmounts.keys {
            contributionAmounts[key] = ""
        }
    }
    
    func getContributionType() {
        isLoading = true
        
        let task = tasks.initialize(ContributionsTypeTask.self)
        
        return task.execute()
            .receive(on:DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { response in
                self.isLoading = false
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { items in
                self.contributionTypes = items
            }))
    }
}
