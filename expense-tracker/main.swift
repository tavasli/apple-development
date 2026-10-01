import Foundation

let store = ExpenseStore()

store.add(Expense(title: "Groceries", amount: 50.0, category: .food))
store.add(Expense(title: "Movie Tickets", amount: 30.0, category: .entertainment))
store.add(Expense(title: "Bus Pass", amount: 20.0, category: .transport))
store.add(Expense(title: "Electricity Bill", amount: 100.0, category: .bills))
store.add(Expense(title: "Dinner", amount: 60.0, category: .food))

print(report(for: store.allExpenses))

print("")

let store2 = ExpenseStore()
print(report(for: store2.allExpenses))
