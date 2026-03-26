import Foundation

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    
    var failureReason: String? {
        underlyingError.failureReason
    }
    
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion?.extractJSONError()
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else {
            return nil
        }
        
        underlyingError = localizedError
    }
}
