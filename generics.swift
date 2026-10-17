import Foundation

// Book ve Tag ekledim çünkü diğer dosyada kaldılar.
struct Book { let title: String }
struct Tag: CustomStringConvertible {
    let name: String
    var description: String { "#\(name)" }
}

func largest<T: Comparable>(_ items: [T]) -> T? {
    items.max()
}
/*
    Comparable kısıtlaması olmadığında max() methodu hata veriyor.
    Sebebi max() methodunun uygulanabileceği tiplerin belirtilmesi isteniyor.
    Bunu da en doğrudan ilgili protocol ile sağlıyoruz.
*/
print(String(describing: largest([3, 9, 1])))
print(String(describing: largest(["c", "k"])))
print(String(describing: largest([Int]())))

struct Stack<Element> {
    private var items: [Element] = []
    
    var count: Int {
        items.count
    }
    
    var top: Element? {
        items.last
    }
    
    mutating func push(_ item: Element) { items.append(item) }
    mutating func pop() -> Element? { items.popLast() }
}

var intStack = Stack<Int>()
intStack.push(1); intStack.push(2)
print(String(describing: intStack.pop()))

var strStack = Stack<String>()
strStack.push("a")
print(String(describing: strStack.top))

extension Stack {
    var isEmpty: Bool { items.count == 0 }
}

extension Stack where Element: Equatable {
    func contains(_ item: Element) -> Bool {
        items.contains(item)
    }
}

extension Stack where Element: Numeric {
    var sum: Element {
        items.reduce(0, +)
    }
}

var s = Stack<Int>(); s.push(2); s.push(3)
print(s.contains(3))
// Numeric protocol uyduğu için doğru çalışır.
print(s.sum)

var t = Stack<String>(); t.push("a")
print(t.contains("a"))

/*
    t.sum
    Numeric protocol uymadığı için hata verir.
*/

// where ile kısıtlama yapalım.
func allEqual<C1: Collection, C2: Collection>(_ a: C1, _ b: C2) -> Bool where C1.Element == C2.Element, C1.Element: Equatable {
    Array(a) == Array(b)
}

print(allEqual([1, 2], Set([1, 2])))
print(allEqual([1, 2], [2, 1]))

protocol Repository {
    associatedtype Item
    var all: [Item] { get }
    mutating func add(_ item: Item)
    func find(where predicate: (Item) -> Bool) -> Item?
}

struct InMemoryRepository<Item>: Repository {
    private(set) var all: [Item] = []
    mutating func add(_ item: Item) { all.append(item) }
    func find(where predicate: (Item) -> Bool) -> Item? { all.first(where: predicate) }
}

extension Repository where Item: CustomStringConvertible {
    func describeAll() -> String {
        all.map(\.description).joined(separator: ", ")
    }
}

var repo = InMemoryRepository<Book>()
repo.add(Book(title: "Dune"))
var itemTitle = repo.find(where: { $0.title.hasPrefix("D") })?.title
print(String(describing: itemTitle))

var tagRepo = InMemoryRepository<Tag>()
tagRepo.add(Tag(name: "swift")); tagRepo.add(Tag(name: "ios"))
print(tagRepo.describeAll())

func countItems(_ c: some Collection) -> Int {
    c.count
}

print(countItems([1, 2, 5]))

func countItemsAny(_ c: any Collection) -> Int {
    c.count
}

print(countItemsAny(["a", "b"]))

func makeRepository() -> some Repository {
    InMemoryRepository<Int>()
}

let made = makeRepository()
print(type(of: made))

func joinAll(_ items: any Collection<String>) -> String {
    items.joined(separator: "-")
}

print(joinAll(["a", "b"]))
