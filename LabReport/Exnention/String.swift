import Foundation

extension String {
    var shortDate: String { self.formattedDate() }
    var longDate: String { self.formattedDate(withTime: true) }
    
    func formattedDate(withTime: Bool = false) -> String {
        // Ignores TimeZone conversion
        guard let date = ISO8601DateFormatter().date(from: String(prefix(19)) + "Z") else { return self }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = withTime ? "MMMM d, yyyy HH:mm:ss" : "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
