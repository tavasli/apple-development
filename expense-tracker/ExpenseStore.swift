import Foundation

enum StoreError: Error {
    case expenseNotFound
}

final class ExpenseStore {
    private var expenses: [Expense] = []

    var allExpenses: [Expense] {
        expenses.sorted(by: { $0.date > $1.date })
    }

    var count: Int {
        expenses.count
    }

    var isEmpty: Bool {
        expenses.isEmpty
    }

    func add(_ expense: Expense) {
        expenses.append(expense)
    }

    func delete(id: UUID) throws {
        guard let index = expenses.firstIndex(where: { $0.id == id }) else {
            throw StoreError.expenseNotFound
        }
        expenses.remove(at: index)
    }

    func expense(at position: Int) -> Expense? {
        let sorted = allExpenses
        guard position >= 1 && position <= sorted.count else {
            return nil
        }
        return sorted[position - 1]
    }
}
