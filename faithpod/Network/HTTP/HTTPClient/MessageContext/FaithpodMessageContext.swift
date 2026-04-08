import Foundation
import Combine
import UIKit

class FaithpodMessageContext: HTTPMessageContextual {
    var scheme: URLScheme = .https
    var host = "\(Config.shared.tenant).\(Config.shared.hostUrl)"
    
    private var authToken: String?
    private var sessionToken: String?
    private var routeId: String?
    private var deviceToken: String?
    
    private let sessionStore: SessionStore
    private var cancellables: Set<AnyCancellable> = []
    
    var headers: [String : String] {
        var contextHeaders = [
            HTTPClient.HeaderKey.contentType.rawValue: "application/json",
            HTTPClient.HeaderKey.acceptEncoding.rawValue: "gzip"
        ]

        if let token = authToken {
            contextHeaders[HTTPClient.HeaderKey.authorization.rawValue] = "Bearer \(token)"
        }

        return contextHeaders
    }
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
        
        sessionStore.currentAuthToken
            .sink { token in
                self.authToken = token
            }.store(in: &cancellables)
        
        sessionStore.currentSessionToken
            .sink { token in
                self.sessionToken = token
            }.store(in: &cancellables)
    }
}
