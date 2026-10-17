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

protocol LoaderDelegate: AnyObject {
    func loaderDidFinish(_ loader: Loader, items: [String])
}

class Loader {
    weak var delegate: LoaderDelegate?

    func load() {
        delegate?.loaderDidFinish(self, items: ["a", "b"])
    }
}

class Screen: LoaderDelegate {
    func loaderDidFinish(_ loader: Loader, items: [String]) {
        print("Delegate received \(items.count) items")
    }
}

let loader = Loader()
let screen = Screen()
loader.delegate = screen
loader.load()

struct Money: Equatable, Comparable, CustomStringConvertible {
    let amount: Decimal
    static func < (l: Money, r: Money) -> Bool { l.amount < r.amount }
    var description: String { "$\(amount)" }
}

let m1 = Money(amount: 10)
let m2 = Money(amount: 20)
print(m1 == m2, m1 < m2, max(m1, m2), [m2, m1].sorted())

struct Tag: Hashable {
    var name: String
}

let tags = Set([Tag(name: "Tag"), Tag(name: "Tag"), Tag(name: "Tag1")])
print(tags.count)

struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

let user = User(id: 1, name: "Mustafa")
let data = try JSONEncoder().encode(user)
print(String(data: data, encoding: .utf8)!)

let back = try JSONDecoder().decode(User.self, from: data)
print(back.name)

extension Array where Element: Describable {
    func titles() -> [String] { map(\.title) }
}

let books = [Book(title: "Dune", author: "Herbert"), Book(title: "Emma", author: "Austen")]
print(books.titles())
