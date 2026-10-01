import Foundation

func total(of expenses: [Expense]) -> Decimal {
    expenses.reduce(0) { $0 + $1.amount }
}

func totalsByCategory(_ expenses: [Expense]) -> [Category: Decimal] {
    var categoryTotals: [Category: Decimal] = [:]
    for expense in expenses {
        categoryTotals[expense.category, default: 0] += expense.amount
    }
    return categoryTotals
}

func topCategory(_ expenses: [Expense]) -> (category: Category, total: Decimal)? {
    guard let best = totalsByCategory(expenses).max(by: { $0.value < $1.value }) else {
        return nil
    }
    return (best.key, best.value)
}

func formatted(_ amount: Decimal) -> String {
    amount.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
}

func report(for expenses: [Expense]) -> String {
    guard !expenses.isEmpty else {
        return "No expenses yet."
    }

    let grandTotal = total(of: expenses)
    let sortedTotals = totalsByCategory(expenses).sorted { $0.value > $1.value }

    var lines: [String] = []

    for (category, amount) in sortedTotals {
        let label = category.displayName.padding(toLength: 15, withPad: " ", startingAt: 0)
        let money = formatted(amount).padding(toLength: 10, withPad: " ", startingAt: 0)
        let share = (amount as NSDecimalNumber).doubleValue / (grandTotal as NSDecimalNumber).doubleValue
        let bar = String(repeating: "█", count: max(1, Int(share * 10)))
        lines.append("\(label)\(money)\(bar)")
    }

    lines.append(String(repeating: "-", count: 35))
    lines.append("Total".padding(toLength: 15, withPad: " ", startingAt: 0) + formatted(grandTotal))

    if let top = topCategory(expenses) {
        lines.append("Top: \(top.category.displayName) (\(formatted(top.total)))")
    }

    return lines.joined(separator: "\n")
}
