import Foundation

class Config {
    enum Property: String {
        case hostUrl = "Host URL"
    }
    
    enum Environment: String {
        case production
    }
    
    static let shared = Config()
    
    private var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    var hostUrl: String {
        return propertyString(forKey: .hostUrl)
    }
    
    private func safePropertyString(for givenBundle: Bundle? = nil, forKey key: Property) -> String? {
        guard let string = (givenBundle ?? bundle).object(forInfoDictionaryKey: key.rawValue) as? String else {
            return nil
        }
        
        return string.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    private func propertyString(for givenBundle: Bundle? = nil, forKey key: Property) -> String {
        guard let string = safePropertyString(for: givenBundle, forKey: key) else {
            fatalError("Info dictionary must specify a String for key \"\(key)\".")
        }
        return string
    }
}


extension Config {
    func printConfigProperties() {
        print("Host URL: \(hostUrl)")
    }
}
