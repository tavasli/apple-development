import Foundation

let expenseStore = ExpenseStore()

expenseStore.add(Expense(date: Date().addingTimeInterval(-7200), title: "Lunch", amount: 250.50, category: .food))
expenseStore.add(Expense(title: "Metro Card", amount: 12.00, category: .transport))
expenseStore.add(Expense(title: "Netflix", amount: 15.99, category: .entertainment))

print("Total expenses: \(expenseStore.count)")

for (index, expense) in expenseStore.allExpenses.enumerated() {
    print("\(index + 1). \(expense.summary)")
}

if let secondExpense = expenseStore.expense(at: 2) {
    do {
        try expenseStore.delete(id: secondExpense.id)
        print("After delete: \(expenseStore.count)")
    } catch StoreError.expenseNotFound {
        print("Error: expense not found")
    }
} else {
    print("Expense at position 2 not found.")
}


do {
    try expenseStore.delete(id: UUID())
} catch StoreError.expenseNotFound {
    print("Error: expense not found")
}


let sharedStore = expenseStore
sharedStore.add(Expense(title: "Gym Membership", amount: 45.00, category: .bills))
print("Original store count: \(expenseStore.count)")
print("Shared store count: \(sharedStore.count)")
