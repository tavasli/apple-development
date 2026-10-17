# Generics

** Diyelim ki iki değeri yer değiştireceksin. Bu değerlerin tipi aynı olsa da her türlü tipte olabilir. Bunu değişken bir yapı haline getirmek istersek generic kullanırız.

** any kullanılırsa tip bilgisi silinmiş olur, generic ise korur.

func swapAny<T>(_ a: inout T, _ b: inout T) {
    let t = a; a = b; b = t
}

var x = 1, y = 2;     swapAny(&x, &y)      // T = Int
var s1 = "a", s2 = "b"; swapAny(&s1, &s2)  // T = String

** <T> belirtmelerinde bir protocol kısıtı getirebiliriz.

func largest<T: Comparable>(_ items: [T]) -> T? { items.max() }

** where komutu ile kısıtlamalar getirilebilir.

func allEqual<C1: Collection, C2: Collection>(_ a: C1, _ b: C2) -> Bool
where C1.Element == C2.Element, C1.Element: Equatable {
    Array(a) == Array(b)
}

allEqual([1, 2], Set([1, 2]))   // true  ← Array ile Set karşılaştırıldı
allEqual([1, 2], [2, 1])        // false

** Int? demek aslında Optional<Int> demekti. Bu da gösteriyor ki tipler de generic olabilir.

** Generic tiplerle extension kullanmak işin püf noktalarından birisidir. Burada where komutu ile detaylandırma yapılır.

extension Stack {
    var isEmpty: Bool { count == 0 }
}

extension Stack where Element: Equatable {
    func contains(_ item: Element) -> Bool { items.contains(item) }
}

extension Stack where Element: Numeric {
    var sum: Element { items.reduce(0, +) }
}

** Protocol için generic kullanımı direkt yapılamaz. Protocol amaç olarak ne yapılacağını tanımlar, tipleri tanımlamaz. Bunun için associated type kullanılır.

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

# Opaque and Boxed Protocol Types

** Aşağıdaki örneği düşünelim.

func f1(_ c: some Collection) -> Int { c.count }   // generic (kısa yazım)
func f2<C: Collection>(_ c: C) -> Int { c.count }  // generic (uzun yazım) — f1 ile AYNI
func f3(_ c: any Collection) -> Int { c.count }    // existential (kutu)

## some

** Somut bir tipi belirtir, bu tipin uyduğu protocol gösterilir ama hangisi olduğu söylenmez.

## any P<T>

** primary associated type dediğimiz bu yaklaşımda aslında "elemanları T olan herhangi bir P" demek istenir.

** Pratikte eğer ki farklı değerlerle çalışmak istenilirse any, yoksa some kullanılır.
