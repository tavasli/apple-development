import Foundation

enum Category: String, CaseIterable {
    case food
    case transport
    case bills
    case entertainment
    case other

    var displayName: String {
        switch self {
            case .food: "Food"
            case .transport: "Transport"
            case .bills: "Bills"
            case .entertainment: "Entertainment"
            case .other: "Other"
        }
    }
}
