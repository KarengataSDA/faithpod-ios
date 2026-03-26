import Foundation
import Combine

struct CustomerRepository: Repository {
    private let client: HTTPClient
    private let sessionStore: SessionStore

    init(client: HTTPClient, sessionStore: SessionStore) {
        self.client = client
        self.sessionStore = sessionStore
    }

    func setCustomerAuthorization(token: String) {
        sessionStore.storeCustomerAuhtorization(token: token)
    }

    func setSessionToken(token: String) {
        sessionStore.storeSessionToken(token: token)
    }

    func authenticate(with taskModel: SignInTask.Model) -> AnyPublisher<PostSignInResponse, Error> {
        let payload = PostSignInRequest.Payload(taskModel: taskModel)
        let request = PostSignInRequest(payload: payload)

        return client.perform(request)
            .receive(on: DispatchQueue.main)
            .tryMap { response in
                self.setCustomerAuthorization(token: response.token)
                self.sessionStore.storeRefreshToken(token: response.refresh_token)
                self.sessionStore.storeTokenExpiry(expiresAt: response.expires_at)
                return response
            }.eraseToAnyPublisher()
    }

    func refreshToken() -> AnyPublisher<PostRefreshTokenResponse, Error> {
        guard let refreshToken = sessionStore.storedRefreshToken() else {
            return Fail(error: HTTPClient.HTTPClientError.unauthorized).eraseToAnyPublisher()
        }

        let request = PostRefreshTokenRequest(refreshToken: refreshToken)

        return client.performWithoutInterception(request)
            .receive(on: DispatchQueue.main)
            .tryMap { response in
                self.setCustomerAuthorization(token: response.token)
                self.sessionStore.storeRefreshToken(token: response.refresh_token)
                self.sessionStore.storeTokenExpiry(expiresAt: response.expires_at)
                return response
            }.eraseToAnyPublisher()
    }

    func getCustomerMe() -> AnyPublisher<Bool, Error> {
        let request = GetCustomerMeRequest()

        return client.perform(request).tryMap { response in
            let customer = Customer(response: response)
            sessionStore.storeCurrentCustomer(customer)
            return true
        }.eraseToAnyPublisher()
    }

    func updateCustomer(with taskModel: UpdateCustomerTask.Model) -> AnyPublisher<Customer, Error> {
        let payload = PutCustomerRequest.Payload(taskModel: taskModel)
        let request = PutCustomerRequest(payload: payload)

        return client.perform(request).tryMap { response in
            let customer = Customer(response: response)
            print("my updates are \(customer)")
            sessionStore.storeCurrentCustomer(customer)
            return customer
        }
        .eraseToAnyPublisher()
    }

    func signOut() {
        sessionStore.clear()
    }

    func forgotPassword(email: String) -> AnyPublisher<PostForgotPasswordResponse, Error> {
        let payload = PostForgotPasswordPayload(email: email)
        let request = PostForgotPasswordRequest(payload: payload)

        return client.perform(request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getCustomerContributions() -> AnyPublisher<[ContributionHistory], Error> {
        let request = GetContributionsRequest()
        return client.perform(request).tryMap { response in
            let contributions = response.contributions.map {
                ContributionHistory(response: $0)
            }

           return contributions
        }
        .eraseToAnyPublisher()
    }

    func getPopulationGroups() -> AnyPublisher<[PopulationGroup], Error> {
        let request = GetGroupsRequest()
        return client.perform(request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getPrayerCells() -> AnyPublisher<[PrayerCell], Error> {
        let request = GetPrayerCellsRequest()
        return client.perform(request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
