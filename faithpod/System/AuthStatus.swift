import Combine
import SwiftUI
import Foundation

class AuthStatus: ObservableObject {
    @Published private(set) var isLoggedIn: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private let sessionStore: SessionStore

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore

        // User is logged in only if both customer AND auth token exist
        Publishers.CombineLatest(sessionStore.currentCustomer, sessionStore.currentAuthToken)
            .map { customer, authToken in
                let loggedIn = customer != nil && authToken != nil
                print("AuthStatus: customer=\(customer != nil), authToken=\(authToken != nil), isLoggedIn=\(loggedIn)")
                return loggedIn
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoggedIn)
    }
}
