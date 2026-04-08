import SwiftUI

struct DependencyContainer: EnvironmentKey {
    let tasks: Tasks
    let state: AppState

    static var defaultValue: Self { Self.default }


    private static var `default` : Self = {
        let keyStore = DefaultKeyStore()
        let keychainStore = KeychainStore()
        let sessionStore = SessionStore(keyStore: keyStore, keychainStore: keychainStore)
        let sessionManager = SessionManager(sessionStore: sessionStore)
        let context = FaithpodMessageContext(sessionStore: sessionStore)
        let client = HTTPClient(context: context, sessionManager: sessionManager)

        let alertStore = AlertStore()

        let repositories = Repositories()

        let customerRepository = CustomerRepository(client: client, sessionStore: sessionStore)
        sessionManager.setCustomerRepository(customerRepository)

        repositories.register(customerRepository)
        repositories.register(AlertRepository(store: alertStore))
        repositories.register(ContributionTypeRepository(client: client))
        repositories.register(ContributionsRepository(client: client))
        repositories.register(TransactionStatusRepository(client: client))
        repositories.register(AnnouncementRepository(client: client))
        repositories.register(HymnalRepository(client: client))

        return Self(
            tasks: Tasks(repositories: repositories),
            state: AppState(sessionStore: sessionStore,
                            alertStore: alertStore,
                            sessionManager: sessionManager)
        )

    }()
}


extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainer.self] }
        set { self[DependencyContainer.self] = newValue }
    }
}
