import Foundation

enum Priority: Int, CaseIterable, Codable {
    case low = 1, medium, high, critical
}

extension Priority: Comparable {
    static func < (l: Priority, r: Priority) -> Bool { l.rawValue < r.rawValue }
}

extension Priority: CustomStringConvertible {
    var description: String {
        switch self {
        case .low: "low"
        case .medium: "medium"
        case .high: "high"
        case .critical: "critical"
        }
    }
}

enum Status: Codable {
    case open
    // Associated value ile özel tipte değerler tutacağız.
    case inProgress(assignee: String)
    case done(resolvedAt: Date)
}

extension Status: CustomStringConvertible {
    var description: String {
        switch self {
        case .open: "open"
        case .inProgress(let assignee): "in progress (\(assignee))"
        case .done(let resolvedAt): "done \(resolvedAt.formatted(date: .abbreviated, time: .omitted))"
        }
    }
}

extension Status {
    var kind: StatusKind {
        switch self {
        case .open: .open
        case .inProgress: .inProgress
        case .done: .done
        }
    }
}

enum StatusKind: String, CaseIterable {
    case open, inProgress, done
}

enum Severity: Int, CaseIterable, Codable {
    case minor = 1, major, blocker
}

extension Severity: Comparable {
    static func < (l: Severity, r: Severity) -> Bool { l.rawValue < r.rawValue }
}

extension Severity: CustomStringConvertible {
    var description: String {
        switch self {
        case .minor: "minor"
        case .major: "major"
        case .blocker: "blocker"
        }
    }
}
