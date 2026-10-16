import Foundation

extension Int {
    var isEven: Bool { self % 2 == 0 }
    var minutesAsHours: String { String(format: "%.1f h", Double(self) / 60) }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var isValidEmail: Bool { contains("@") && !hasPrefix("@") }
}

print(5.isEven)
print(67.minutesAsHours)
print("  protocols ".trimmed)
print("@hi".isValidEmail)

struct Workout {
    var name: String
    var minutes: Int
}

extension Workout {
    // extension custom init oluşturalım.
    init(quick name: String) {
        self.init(name: name, minutes: 15)
    }
}

let running = Workout(name: "Run", minutes: 30)
let walking = Workout(quick: "Walk")
print(running.minutes)
print(walking.minutes)

protocol Describable {
    var title: String { get }
    var detail: String { get }
    
    func describe() -> String
}

extension Describable {
    var detail: String { "no detail" }

    func describe() -> String {
        "\(title) - \(detail)"
    }
}

struct Book: Describable {
    let title: String
    let author: String

    var detail: String { "by \(author)" }
}

struct Note: Describable {
    var title: String
}

print(Book(title: "Dune", author: "Herbert").describe())
print(Note(title: "Groceries").describe())

let describables: [any Describable] = [Book(title: "White Nights", author: "Dostoyevski"), Note(title: "Swift")]
for describable in describables {
    print(describable.describe())
}
