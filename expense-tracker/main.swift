import Foundation

let lunch = Expense(title: "Lunch", amount: 250.50, category: .food)
let metro = Expense(title: "Metro Card", amount: 12.00, category: .transport)
let netflix = Expense(title: "Netflix", amount: 15.99, category: .entertainment)

print(lunch.summary)
print(metro.summary)
print(netflix.summary)
print("")
print("Categories:")
for category in Category.allCases {
    print("\(category) -> \(category.displayName)")
}
