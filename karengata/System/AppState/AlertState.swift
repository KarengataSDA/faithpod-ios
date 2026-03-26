import Foundation
import Combine

class AlertState: ObservableObject {
    @Published private(set) var alertMessage: AlertMessage?
    
    private var cancellables: Set<AnyCancellable> = []
    private let alertStore: AlertStore
    
    init(alertStore: AlertStore) {
        self.alertStore = alertStore
        
        alertStore.messageForDisplay
            .receive(on: DispatchQueue.main)
            .sink { alertMessage in
                self.alertMessage = alertMessage
            }.store(in: &cancellables)
    }
}
