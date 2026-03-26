import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.dependencies.state) var appState
    @Environment(\.dependencies.tasks) var tasks
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var updateService = AppUpdateService.shared
    @StateObject private var sessionValidator = SessionValidator()
    @State private var didShowSplash = false
    @State private var showSessionExpiredAlert = false
    @State private var selectedTab: RootNavigationView.Tab = .home

    var body: some View {
        Group {
            if !didShowSplash {
                BaseView {
                    SplashView(splashCompleted: $didShowSplash)
                }
            } else if updateService.isUpdateAvailable {
                // Force update screen - blocks the entire app
                ForceUpdateView()
            } else {
                BaseView {
                    RootNavigationView(selectedTab: $selectedTab)
                        .environmentObject(appState.authStatus)
                        .environmentObject(appState.sessionCustomer)
                }
            }
        }
        .onAppear {
            Config.shared.printConfigProperties()
        }
        .onChange(of: didShowSplash) { newValue in
            if newValue {
                updateService.checkForUpdate()
                validateSessionIfNeeded()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active && didShowSplash {
                // When app returns to foreground, proactively refresh if token is near expiry
                refreshTokenIfNeeded()
            }
        }
        .onReceive(appState.sessionManager.sessionExpired) { _ in
            showSessionExpiredAlert = true
        }
        .alert("Session Expired", isPresented: $showSessionExpiredAlert) {
            Button("OK", role: .cancel) {
                selectedTab = .account
            }
        } message: {
            Text("Your session has expired. Please log in again.")
        }
    }

    private func validateSessionIfNeeded() {
        guard appState.sessionStore.currentAuthToken.value != nil else { return }
        let task = tasks.initialize(GetCustomerMeTask.self)
        sessionValidator.validate(
            task: task,
            sessionStore: appState.sessionStore
        )
    }

    private func refreshTokenIfNeeded() {
        let sessionStore = appState.sessionStore
        guard sessionStore.currentAuthToken.value != nil else { return }

        // If token is expired or close to expiry (within 5 minutes), refresh proactively
        if sessionStore.isTokenExpired() && sessionStore.storedRefreshToken() != nil {
            print("🔄 ContentView: token expired on resume, attempting proactive refresh")
            sessionValidator.refreshAndValidate(
                sessionManager: appState.sessionManager,
                task: tasks.initialize(GetCustomerMeTask.self),
                sessionStore: sessionStore
            )
        }
    }
}

/// Helper class to hold the session validation subscription
private class SessionValidator: ObservableObject {
    private var cancellable: AnyCancellable?

    func validate(task: GetCustomerMeTask, sessionStore: SessionStore) {
        cancellable = task.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("🔴 Session validation failed: \(error)")
                        // Only clear session for definitive auth failures (unauthorized)
                        // Do NOT clear for transient errors (network, timeout, server errors)
                        // The HTTPClient already attempts token refresh on 401 before this point
                        if Self.isSessionInvalidError(error) {
                            print("🔴 Clearing session due to auth failure")
                            sessionStore.clear()
                        } else {
                            print("🟡 Transient error during validation - keeping session")
                        }
                    }
                },
                receiveValue: { _ in
                    print("✅ Session validated successfully")
                }
            )
    }

    func refreshAndValidate(sessionManager: SessionManaging, task: GetCustomerMeTask, sessionStore: SessionStore) {
        cancellable = sessionManager.attemptTokenRefresh()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    print("✅ Proactive token refresh succeeded, validating session")
                    self?.validate(task: task, sessionStore: sessionStore)
                } else {
                    print("🔴 Proactive token refresh failed")
                }
            }
    }

    private static func isSessionInvalidError(_ error: Error) -> Bool {
        if let clientError = error as? HTTPClient.HTTPClientError {
            switch clientError {
            case .unauthorized:
                return true
            default:
                return false
            }
        }
        return false
    }
}

#Preview {
    ContentView()
}
