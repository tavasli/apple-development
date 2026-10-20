import Foundation

class Person {
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) deinit")
    }
}

var p1: Person? = Person(name: "Mustafa")
var p2 = p1
p1 = nil
// p1 nil oldu ama p2 hâlâ tutuyor, sayaç 1'de.
print("p1 nil, hâlâ yaşıyor: \(p2?.name ?? "-")")
p2 = nil
// İşaret eden referans kalmadı, deinit çalışır.

class Owner {
    var pet: Pet?
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Owner \(name) deinit")
    }
}

class Pet {
    var owner: Owner?
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Pet \(name) deinit")
    }
}

do {
    let o = Owner(name: "Sude")
    let p = Pet(name: "Mişa")

    o.pet = p
    p.owner = o
}
// Blok bitti ama ikisi birbirini tuttuğu için hiçbir deinit çalışmaz.

class Owner2 {
    var pet: Pet2?
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Owner2 \(name) deinit")
    }
}

class Pet2 {
    // Sahiplik yönü Owner2 -> Pet2 olduğu için geri yön zayıf tutulur.
    weak var owner: Owner2?
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Pet2 \(name) deinit")
    }
}

do {
    let o = Owner2(name: "Sude")
    let p = Pet2(name: "Mişa")

    o.pet = p
    p.owner = o
}

class Customer {
    var creditCard: CreditCard?
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Customer \(name) deinit")
    }
}

class CreditCard {
    // Kredi kartı müşteri olmadan var olamaz ve müşteriden önce ölür, unowned uygun.
    unowned let customer: Customer
    let number: String

    init(customer: Customer, number: String) {
        self.customer = customer
        self.number = number
    }

    deinit {
        print("CreditCard \(number) deinit")
    }
}

do {
    let customer = Customer(name: "Ahmet")
    customer.creditCard = CreditCard(customer: customer, number: "9876")
}

class Screen {
    var name = "Screen"
    var onUpdate: (() -> Void)?

    // self güçlü yakalanıyor. Screen closure'ı, closure da Screen'i tutar.
    func setupStrong() {
        onUpdate = { print("strong: \(self.name)") }
    }

    // capture list ile zayıf yakalama, döngü kırılır.
    func setupWeak() {
        onUpdate = { [weak self] in
            print("weak: \(self?.name ?? "-")")
        }
    }

    func setupWeakGuard() {
        onUpdate = { [weak self] in
            guard let self else { return }
            print("weak guard: \(self.name)")
        }
    }

    deinit {
        print("\(name) deinit")
    }
}

do {
    let screen = Screen()
    screen.setupStrong()
    screen.onUpdate?()
}

do {
    let screen = Screen()
    screen.setupWeak()
    screen.onUpdate?()
}

do {
    let screen = Screen()
    screen.setupWeakGuard()
    screen.onUpdate?()
}

var counter = 10
let captured = { [counter] in print("captured: \(counter)") }
let referenced = { print("referenced: \(counter)") }
counter = 99
captured()
referenced()

struct Workout {
    enum Kind: String { case run, swim }
    struct Interval { let minutes: Int }

    let kind: Kind
    let intervals: [Interval]
}

let workout = Workout(kind: .run, intervals: [Workout.Interval(minutes: 5), Workout.Interval(minutes: 10)])
print("\(workout.kind.rawValue): \(workout.intervals.count) interval")
