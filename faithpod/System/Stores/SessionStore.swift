import SwiftUI
import Foundation
import Combine

class SessionStore {
    private static let currentCustomer = "current_customer"
    private static let customerAuthorizationKey = "customer_authorization_key"
    private static let sessionKey = "session_key"
    private static let routeKey = "route_key"
    private static let customerDeviceTokenKey = "customer_device_token"
    private static let firstTimeNovadine = "first_time_novadine"
    private static let popUpMessageKey = "pop_up_message"
    private static let refreshTokenKey = "refresh_token_key"
    private static let tokenExpiresAtKey = "token_expires_at_key"

    private var keyStore: KeyStore
    private var keychainStore: KeychainStore

    var currentCustomer = CurrentValueSubject<Customer?, Never>(nil)
    var currentAuthToken = CurrentValueSubject<String?, Never>(nil)
    var currentSessionToken = CurrentValueSubject<String?, Never>(nil)
    var currentRouteId = CurrentValueSubject<String?, Never>(nil)
    var currentDeviceToken = CurrentValueSubject<String?, Never>(nil)
    var currentRefreshToken = CurrentValueSubject<String?, Never>(nil)
    var tokenExpiresAt = CurrentValueSubject<Int64?, Never>(nil)

    init(keyStore: KeyStore, keychainStore: KeychainStore = KeychainStore()) {
        self.keyStore = keyStore
        self.keychainStore = keychainStore

        // Migrate auth token from UserDefaults to Keychain if needed
        if let legacyToken = keyStore.get(SessionStore.customerAuthorizationKey) as? String,
           keychainStore.get(SessionStore.customerAuthorizationKey) == nil {
            keychainStore.set(value: legacyToken, for: SessionStore.customerAuthorizationKey)
            keyStore.clearValue(for: SessionStore.customerAuthorizationKey)
        }

        // Session is only valid if both customer AND auth token exist
        // If either is missing, clear everything to ensure clean state
        let hasCustomer = storedCurrentCustomer() != nil
        let hasAuthToken = storedAuthToken() != nil

        if hasCustomer != hasAuthToken {
            clearStoredSession()
        }

        currentCustomer.send(storedCurrentCustomer())
        currentAuthToken.send(storedAuthToken())
        currentSessionToken.send(storedSessionToken())
        currentRouteId.send(storedRouteId())
        currentDeviceToken.send(storedDeviceToken())
        currentRefreshToken.send(storedRefreshToken())
        tokenExpiresAt.send(storedTokenExpiresAt())
    }

    func storeRouteId(routeId: String) {
        keyStore.set(value: routeId, for: SessionStore.routeKey)

        currentRouteId.send(routeId)
    }

    func storeCurrentCustomer(_ customer: Customer) {
        guard let encodedCustomer = try? JSONEncoder().encode(customer) else{
            return
        }
        keyStore.set(value: encodedCustomer, for: SessionStore.currentCustomer)
        currentCustomer.send(customer)
    }

    func storeCustomerAuhtorization(token: String) {
        keychainStore.set(value: token, for: SessionStore.customerAuthorizationKey)

        currentAuthToken.send(token)
    }

    func storeSessionToken(token: String ) {
        keyStore.set(value: token, for: SessionStore.sessionKey)
        currentSessionToken.send(token)
    }

    func storeRefreshToken(token: String) {
        keychainStore.set(value: token, for: SessionStore.refreshTokenKey)
        currentRefreshToken.send(token)
    }

    func storeTokenExpiry(expiresAt: Int64) {
        keychainStore.set(value: String(expiresAt), for: SessionStore.tokenExpiresAtKey)
        tokenExpiresAt.send(expiresAt)
    }

    func isTokenExpired() -> Bool {
        guard let expiresAt = storedTokenExpiresAt() else { return true }
        let now = Int64(Date().timeIntervalSince1970 * 1000)
        return now >= expiresAt
    }

    func storedDeviceToken() -> String? {
        return keyStore.get(SessionStore.customerDeviceTokenKey) as? String
    }

    func storedRouteId() -> String? {
        return keyStore.get(SessionStore.routeKey) as? String
    }

    func storedSessionToken() -> String? {
        return keyStore.get(SessionStore.sessionKey) as? String
    }

    func storedAuthToken() -> String? {
        return keychainStore.get(SessionStore.customerAuthorizationKey) as? String
    }

    func storedCurrentCustomer() -> Customer? {
        guard let data = keyStore.get(SessionStore.currentCustomer) as? Data else {
            return nil
        }

        return try? JSONDecoder().decode(Customer.self, from: data)
    }

    func storedRefreshToken() -> String? {
        return keychainStore.get(SessionStore.refreshTokenKey) as? String
    }

    func storedTokenExpiresAt() -> Int64? {
        guard let value = keychainStore.get(SessionStore.tokenExpiresAtKey) as? String else {
            return nil
        }
        return Int64(value)
    }

    private func clearStoredSession() {
        keyStore.clearValue(for: SessionStore.currentCustomer)
        keyStore.clearValue(for: SessionStore.sessionKey)
        keyStore.clearValue(for: SessionStore.routeKey)
        keyStore.clearValue(for: SessionStore.customerDeviceTokenKey)
        keychainStore.clearValue(for: SessionStore.customerAuthorizationKey)
        keychainStore.clearValue(for: SessionStore.refreshTokenKey)
        keychainStore.clearValue(for: SessionStore.tokenExpiresAtKey)
    }

    func clear() {
       
        clearStoredSession()

        currentCustomer.send(nil)
        currentAuthToken.send(nil)
        currentSessionToken.send(nil)
        currentRouteId.send(nil)
        currentDeviceToken.send(nil)
        currentRefreshToken.send(nil)
        tokenExpiresAt.send(nil)
       
    }
}
