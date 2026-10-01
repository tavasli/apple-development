import Foundation

let store = ExpenseStore()
store.add(Expense(title: "Lunch at work", amount: Decimal(string: "250.50")!, category: .food))
store.add(Expense(title: "Metro", amount: Decimal(string: "12.00")!, category: .transport))
store.add(Expense(title: "Netflix", amount: Decimal(string: "15.99")!, category: .entertainment))

func printHelp() {
    let categories = Category.allCases.map { $0.rawValue }.joined(separator: ", ")
    print("""
    Commands:
      add <amount> <category> <title>   Add an expense
      list                              List all expenses
      report                            Show category report
      delete <position>                 Delete an expense
      help                              Show this help
      quit                              Exit
      total                             Show total expenses
    Categories: \(categories)
    """)
}

func printList() {
    guard !store.isEmpty else {
        print("No expenses yet.")
        return
    }
    for (index, expense) in store.allExpenses.enumerated() {
        print("\(index + 1). \(expense.summary)")
    }
}

print("Expense Tracker")
print("Type 'help' for commands.")

mainLoop: while true {
    print("> ", terminator: "")
    guard let input = readLine() else { break }

    do {
        let command = try parse(input: input)

        switch command {
        case let .add(title, amount, category):
            let expense = Expense(title: title, amount: amount, category: category)
            store.add(expense)
            print("Added: \(expense.summary)")

        case .list:
            printList()

        case .report:
            print(report(for: store.allExpenses))

        case let .delete(position):
            guard let expense = store.expense(at: position) else {
                print("No expense at position \(position).")
                continue
            }
            try store.delete(id: expense.id)
            print("Deleted: \(expense.title)")

        case .help:
            printHelp()

        case .quit:
            print("Bye.")
            break mainLoop
        
        case .total:
            print("Total spent: \(formatted(total(of: store.allExpenses)))")
        }
    } catch let error as CommandError {
        print("Error: \(error.message)")
    } catch StoreError.expenseNotFound {
        print("Error: expense not found")
    } catch {
        print("Unexpected error: \(error)")
    }
}
