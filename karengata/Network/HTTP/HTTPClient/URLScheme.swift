struct URLSchemeConstants {
    static let http = "http://"
    static let https = "https://"
}

enum URLScheme: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case URLSchemeConstants.http:
            self = .http
            
        case URLSchemeConstants.https:
            self = .https
            
        default:
            self = .custom(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .http:
            return URLSchemeConstants.http
            
        case .https:
            return URLSchemeConstants.https
            
        case .custom(let string):
            return string
        }
    }
    
    case http
    case https
    case custom(String)
    
}
