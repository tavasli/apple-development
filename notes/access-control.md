# Access Control

** Kodun parçalarının nereden erişilebileceğini belirtmemizi sağlar.

- open          Başka modüllerden erişilir ve miras alınabilir (sadece class/metot)
- public        Başka modüllerden erişilir, miras alınamaz
- package	    Aynı paket içindeki modüllerden
- internal	    Varsayılan. Aynı modül içinden
- fileprivate	Aynı dosya içinden
- private	    Aynı tanım (ve aynı dosyadaki extension'ları) içinden

** private(set) ile atanan property dışarıdan okunur ama değiştirilemez. Gerçek senaryolarda sık kullanılır.

# Macros

** Swift'in yeni özelliklerinden birisidir. Derleme zamanında kod üretir.
** Kendimiz yazmayız, SwiftUI tarafında çok kullanırız. Ne olduğunu bilip örnek vermek yeterlidir.

# Advanced Operators

** Mantık operatörleri örnek verilebilir.

let flags: UInt8 = 0b0000_1100
flags & 0b0000_0100    // 4    AND
flags | 0b0000_0001    // 13   OR
flags ^ 0b0000_1000    // 4    XOR
~flags                 // 243  NOT
1 << 3                 // 8    sola kaydır (×8)
16 >> 2                // 4    sağa kaydır (÷4)

## Operator Overloading

** Kendi tiplerimiz için standard operatörler yazabiliriz.

struct Vector: Equatable {
    var x: Double
    var y: Double

    static func + (l: Vector, r: Vector) -> Vector { Vector(x: l.x + r.x, y: l.y + r.y) }
    static prefix func - (v: Vector) -> Vector { Vector(x: -v.x, y: -v.y) }
    static func += (l: inout Vector, r: Vector) { l = l + r }
}

v1 + v2        // Vector(x: 4.0, y: 6.0)
-v1            // Vector(x: -1.0, y: -2.0)
v1 == v2       // Equatable'dan otomatik

## Custom Operator

** Kendi operatörlerimizi yazabiliriz, ne kadar tavsiye edilmese de.

infix operator **: MultiplicationPrecedence
func ** (base: Double, power: Double) -> Double { pow(base, power) }

2.0 ** 10.0          // 1024.0
2.0 + 3.0 ** 2.0     // 11.0  ← ** önce çalıştı
