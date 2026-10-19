import Foundation

enum RepositoryError: Error, LocalizedError {
    case issueNotFound(id: UUID)

    var errorDescription: String? {
        switch self {
            case .issueNotFound(let id):
                "Couldn't find the item with id: \(id)"
        }
    }
}

struct IssueRepository<Item: Trackable> {
    private var items: [Item] = []
    var all: [Item] { items }
    var count: Int { items.count }

    mutating func add(_ item: Item) {
        items.append(item)
    }

    func find(where predicate: (Item) -> Bool) -> Item? { items.first(where: predicate) }

    mutating func delete(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            throw RepositoryError.issueNotFound(id: id)
        }
        items.remove(at: index)
    }
}
