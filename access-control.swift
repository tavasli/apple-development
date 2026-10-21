import Foundation

struct BankAccount {
    private var balance: Decimal = 0
    private(set) var transactionCount = 0

    fileprivate var auditNote = "Internal Audit"

    mutating func deposit(_ amount: Decimal) {
        balance += amount
        transactionCount += 1
    }

    var readBalance: String {
        "Your balance: \(balance)"
    }
}

struct Reporter {
    func report(_ account: BankAccount) -> String {
        // account.balance
        // fileprivate olduğu için erişilebilir.
        account.auditNote
    }
}

var account = BankAccount()
account.deposit(500)
account.deposit(1000)
// account.balance
print(account.transactionCount)
// account.transactionCount = 5
print(account.readBalance)

struct Vector: Equatable {
    var x: Double
    var y: Double

    static func + (l: Vector, r: Vector) -> Vector { Vector(x: l.x + r.x, y: l.y + r.y) }
    static prefix func - (v: Vector) -> Vector { Vector(x: -v.x, y: -v.y) }
    static func += (l: inout Vector, r: Vector) { l = l + r }
}

var v1 = Vector(x: 1, y: 2)
let v2 = Vector(x: 3, y: 4)

print(v1 + v2)
print(-v1)
v1 += v2
print(v1)
print(v1 == v2)
