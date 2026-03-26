import Foundation

struct AppState {
    let sessionStore: SessionStore
    let alertStore: AlertStore
    let sessionManager: SessionManaging

    let authStatus: AuthStatus
    let sessionCustomer: SessionCustomer

    let alertState: AlertState


    init(sessionStore: SessionStore, alertStore: AlertStore, sessionManager: SessionManaging) {
        self.sessionStore = sessionStore
        self.sessionManager = sessionManager

        self.authStatus = AuthStatus(sessionStore: sessionStore)
        self.sessionCustomer = SessionCustomer(sessionStore: sessionStore)

        self.alertStore = alertStore
        self.alertState = AlertState(alertStore: alertStore)
    }
}
