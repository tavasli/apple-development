# Extensions

** Var olan bir tipe istediğimiz eklemeleri yapmayı sağlar. Apple tarafında yerleşik bulunan tipler de buna dahildir.
** computed property, metot, initializer, subscript, nested type, protocol conformance ekleyebiliriz.

** Custom init extension ile yazılırsa memberwise init de kullanılabilir.

struct Workout {
    var name: String
    var minutes: Int
}

extension Workout {
    init(quick name: String) { self.init(name: name, minutes: 15) }
}

Workout(name: "Run", minutes: 30)   // memberwise hâlâ var
Workout(quick: "Walk")              // custom init de var

# Protocols

** "Bu protokole uyan her tip şunları sağlamak zorundadır" ifadesini sağlar.
** Protocolde property en azından get olmalı, metodların ise gövdesi yazılamaz. Property değiştirecek bir durum varsa mutating kullanılır.

## Protocol Extension

** En önemli nokta burası. Swift'e "protocol oriented" denmesinin sebebi class yapılarındaki ortak davranış paylaşımını struct ve enum için de mümkün kılabiliyor olmaktır.

** Aşağıdaki örnekte extend edilmiş bir protocolde varsayılan kullanımını görebiliriz.

extension Describable {
    var detail: String { "no detail" }
    func describe() -> String { "\(title) — \(detail)" }
}

struct Note: Describable {
    let title: String        // detail ve describe() yazmadı!
}

Note(title: "Groceries").describe()   // "Groceries — no detail"
Book(title: "Dune", author: "Herbert").describe()  // "Dune — by Herbert"

** Protocol bir tiptir. Herhangi bir tip birden fazla protocol uyabilir, & işareti ile kullanılır. Hatta bir protocol başka protocollere de uyabilir.

** Aşağıdaki protocoller sıklıkla karşılaştıklarımızdandır.

struct User: Codable, Identifiable {
    let id: Int
    let name: String
}
let data = try JSONEncoder().encode(user)   // {"id":1,"name":"Mustafa"}
let back = try JSONDecoder().decode(User.self, from: data)

## some vs any

** some: Arkasında yazılan protocole uyan bir tip almasını belirtir. Tip derleme aşamasında bellidir.

func describeSome(_ shape: some Shape) -> String { "area \(shape.area)" }
func describeGeneric<T: Shape>(_ shape: T) -> String { "area \(shape.area)" }

** any: Tip çalışma aşamasında bellidir.

** Pratik kural: Varsayılan olarak some kullan. any'yi sadece farklı tipleri bir arada tutman gerektiğinde kullan.
