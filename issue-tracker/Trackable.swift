import Foundation

protocol Trackable: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var createdAt: Date { get }

    var status: Status { get set }
    var priority: Priority { get set }

    var summary: String { get }
}

extension Trackable {
    var summary: String {
        "\(title) - \(priority) - \(status)"
    }
}
