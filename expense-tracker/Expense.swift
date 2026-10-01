import Foundation

struct Expense {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String
    var amount: Decimal
    var category: Category

    var formattedAmount: String {
        amount.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
    }

    var summary: String {
        "\(title) - \(formattedAmount) - \(category.displayName)"
    }
}
