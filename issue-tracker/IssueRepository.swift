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

    func countByStatus() -> [StatusKind: Int] {
        var counts: [StatusKind: Int] = [:]
        
        for item in items {
            counts[item.status.kind, default: 0] += 1
        }
        
        return counts
    }

    func countByPriority() -> [Priority: Int] {
        var counts: [Priority: Int] = [:]
        
        for item in items {
            counts[item.priority, default: 0] += 1
        }
        
        return counts
    }

    mutating func add(_ item: Item) {
        items.append(item)
    }

    func find(where predicate: (Item) -> Bool) -> Item? { items.first(where: predicate) }

    func sortedByPriority() -> [Item] {
        items.sorted { lhs, rhs in
            if lhs.priority == rhs.priority {
                return lhs.createdAt > rhs.createdAt
            } else {
                return lhs.priority > rhs.priority
            }
        }
    }

    mutating func delete(id: UUID) throws {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            throw RepositoryError.issueNotFound(id: id)
        }
        items.remove(at: index)
    }
}

extension IssueRepository where Item: Codable {
    func save(to url: URL) throws {
        let data = try JSONEncoder().encode(items)
        try data.write(to: url)
    }

    mutating func load(from url: URL) throws {
        let data = try Data(contentsOf: url)
        items = try JSONDecoder().decode([Item].self, from: data)
    }
}
