import Combine
import SwiftUI

class SessionCustomer: ObservableObject {
    @Published private(set) var customer: Customer?
    @Published private(set) var authToken: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let sessionStore: SessionStore
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
        
        sessionStore.currentCustomer
            .receive(on:DispatchQueue.main)
            .sink { customer in
                self.customer = customer
            }.store(in: &cancellables)
        
        sessionStore.currentAuthToken
            .receive(on: DispatchQueue.main)
            .sink { token in
                self.authToken = token
            }.store(in: &cancellables)
    }
}
