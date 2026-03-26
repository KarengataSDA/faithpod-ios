import Foundation
import Combine

protocol SessionManaging {
    var sessionExpired: AnyPublisher<Void, Never> { get }
    func handleUnauthorized()
    func attemptTokenRefresh() -> AnyPublisher<Bool, Never>
}

class SessionManager: SessionManaging {
    private let sessionStore: SessionStore
    private let sessionExpiredSubject = PassthroughSubject<Void, Never>()
    private var customerRepository: CustomerRepository?
    private var cancellables: Set<AnyCancellable> = []

    // Thread-safe refresh: only one refresh at a time
    private let refreshLock = NSLock()
    private var isRefreshing = false
    private var refreshResultSubject: PassthroughSubject<Bool, Never>?

    var sessionExpired: AnyPublisher<Void, Never> {
        sessionExpiredSubject.eraseToAnyPublisher()
    }

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }

    func setCustomerRepository(_ repository: CustomerRepository) {
        self.customerRepository = repository
    }

    private func isAuthError(_ error: Error) -> Bool {
        guard let clientError = error as? HTTPClient.HTTPClientError else { return false }
        switch clientError {
        case .unauthorized:
            return true
        case .message(let code, _) where code == 401:
            return true
        default:
            return false
        }
    }

    func handleUnauthorized() {
        DispatchQueue.main.async { [weak self] in
            self?.sessionStore.clear()
            self?.sessionExpiredSubject.send()
        }
    }

    func attemptTokenRefresh() -> AnyPublisher<Bool, Never> {
        refreshLock.lock()

        // If already refreshing, subscribe to the existing result
        if isRefreshing, let existingSubject = refreshResultSubject {
            refreshLock.unlock()
            return existingSubject.first().eraseToAnyPublisher()
        }

        guard let repository = customerRepository,
              sessionStore.storedRefreshToken() != nil else {
            refreshLock.unlock()
            return Just(false).eraseToAnyPublisher()
        }

        isRefreshing = true
        let subject = PassthroughSubject<Bool, Never>()
        refreshResultSubject = subject
        refreshLock.unlock()

        print("🔄 SessionManager: attempting token refresh")

        repository.refreshToken()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case .failure(let error) = completion {
                        // Only clear the session for definitive auth failures.
                        // Transient errors (network, server) should not log the user out.
                        if self.isAuthError(error) {
                            self.handleUnauthorized()
                        }
                        subject.send(false)
                    }
                    subject.send(completion: .finished)
                    self.refreshLock.lock()
                    self.isRefreshing = false
                    self.refreshResultSubject = nil
                    self.refreshLock.unlock()
                },
                receiveValue: { _ in
                    subject.send(true)
                }
            )
            .store(in: &cancellables)

        return subject.first().eraseToAnyPublisher()
    }
}
