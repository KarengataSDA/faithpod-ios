import Foundation
import Combine
import UIKit

struct AppStoreResponse: Decodable {
    let resultCount: Int
    let results: [AppStoreResult]
}

struct AppStoreResult: Decodable {
    let version: String
    let releaseNotes: String?
    let trackViewUrl: String
}

class AppUpdateService: ObservableObject {
    static let shared = AppUpdateService()

    private let appStoreId = "6749389315"
    private let appStoreUrl = "https://apps.apple.com/app/id6749389315"

    @Published var isUpdateAvailable: Bool = false
    @Published var latestVersion: String = ""
    @Published var releaseNotes: String?
    @Published var hasChecked: Bool = false
    @Published var userDismissedUpdate: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private init() {}

    func checkForUpdate() {
        guard !hasChecked else { return }

        let urlString = "https://itunes.apple.com/lookup?id=\(appStoreId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AppStoreResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to check for update: \(error)")
                }
                self.hasChecked = true
            }, receiveValue: { [weak self] response in
                guard let self = self,
                      let result = response.results.first else { return }

                self.latestVersion = result.version
                self.releaseNotes = result.releaseNotes
                self.isUpdateAvailable = self.isVersionNewer(result.version, than: self.currentVersion)
            })
            .store(in: &cancellables)
    }

    private func isVersionNewer(_ appStoreVersion: String, than currentVersion: String) -> Bool {
        let appStoreComponents = appStoreVersion.split(separator: ".").compactMap { Int($0) }
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }

        let maxCount = max(appStoreComponents.count, currentComponents.count)

        for i in 0..<maxCount {
            let appStoreValue = i < appStoreComponents.count ? appStoreComponents[i] : 0
            let currentValue = i < currentComponents.count ? currentComponents[i] : 0

            if appStoreValue > currentValue {
                return true
            } else if appStoreValue < currentValue {
                return false
            }
        }

        return false
    }

    func openAppStore() {
        guard let url = URL(string: appStoreUrl) else { return }
        UIApplication.shared.open(url)
    }

    func dismissUpdate() {
        userDismissedUpdate = true
    }

    func resetDismissal() {
        userDismissedUpdate = false
    }

    var shouldShowUpdateBanner: Bool {
        isUpdateAvailable && !userDismissedUpdate
    }
}
