import Foundation

extension String {
    func extractJSONError() -> String {
        let stringData = Data(self.utf8)
        let decoder = JSONDecoder()
        if let stringObject  = try? decoder.decode(JSONErrorMessage.self, from: stringData) {
            return stringObject.error
        }
        
        return self
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
    
    func toFormattedDisplay() -> String {
        guard let date = self.toDate() else { return self }
        let output = DateFormatter()
        output.dateStyle = .medium
        return output.string(from: date)
    }
    
    func truncated(to length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index]) + "..."
        }
        return self
    }
}

private struct JSONErrorMessage: Decodable {
    let error: String
}
