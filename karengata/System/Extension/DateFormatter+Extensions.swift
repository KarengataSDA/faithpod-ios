import Foundation

extension DateFormatter {
    static var displayDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
