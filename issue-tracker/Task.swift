import Foundation

struct Task: Trackable, Codable {
    let id: UUID
    let title: String
    let createdAt: Date
    var status: Status
    var priority: Priority

    var estimatedTime: Double?

    init(id: UUID = UUID(), title: String, createdAt: Date = Date(), status: Status = .open, priority: Priority, estimatedTime: Double? = nil) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.status = status
        self.priority = priority
        self.estimatedTime = estimatedTime
    }
}
