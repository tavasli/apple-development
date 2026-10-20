import Foundation

struct Bug: Trackable, Codable {
    let id: UUID
    let title: String
    let createdAt: Date
    var status: Status
    var priority: Priority
    var severity: Severity

    var affectedVersion: String?

    // struct olduğu için methodu direkt yeniden yazabiliriz, override kullanmaya gerek yok.
    var summary: String {
        "\(title) - \(priority) - \(status) (\(affectedVersion ?? "unknown"), \(severity))"
    }

    init(id: UUID = UUID(), title: String, createdAt: Date = Date(), status: Status = .open, priority: Priority, severity: Severity, affectedVersion: String? = nil) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.status = status
        self.priority = priority
        self.severity = severity
        self.affectedVersion = affectedVersion
    }
}
