# Swift Başucu Rehberi

Bu rehber, *The Swift Programming Language* kitabının Language Guide bölümlerini kitaptaki sırayla özetler. Amacı, Swift tarafında bir mülakata ya da günlük işe hazırlanırken tek kaynaktan hızlıca tekrar yapabilmektir. Her bölümde temel kurallar, gerçek projelerde karşılaşılan kullanım şekilleri, tercihlerin gerekçeleri ve sık yapılan hatalar yer alır. Bölüm sonlarındaki mülakat sorularının cevapları kapalı gelir. Önce cevabı kendin ver, sonra açıp karşılaştır.

Kod örnekleri Swift 6 ile derlenmiştir. Her örnekte `import Foundation` satırının bulunduğu varsayılır.

Renkli kutuların anlamı:

> [!NOTE]
> Ek bilgi ve bağlam.

> [!TIP]
> Tercih: hangi durumda hangi yolun seçileceği.

> [!IMPORTANT]
> Mülakatta mutlaka bilinmesi gereken kural.

> [!WARNING]
> Sık yapılan hata ya da tuzak.

> [!CAUTION]
> Çalışma anında crash ya da ciddi bug'a yol açan durum.

## İçindekiler

1. [The Basics](#1-the-basics)
2. [Basic Operators](#2-basic-operators)
3. [Strings and Characters](#3-strings-and-characters)
4. [Collection Types](#4-collection-types)
5. [Control Flow](#5-control-flow)
6. [Functions](#6-functions)
7. [Closures](#7-closures)
8. [Enumerations](#8-enumerations)
9. [Structures and Classes](#9-structures-and-classes)
10. [Properties](#10-properties)
11. [Methods](#11-methods)
12. [Subscripts](#12-subscripts)
13. [Inheritance](#13-inheritance)
14. [Initialization](#14-initialization)
15. [Deinitialization](#15-deinitialization)
16. [Optional Chaining](#16-optional-chaining)
17. [Error Handling](#17-error-handling)
18. [Concurrency](#18-concurrency)
19. [Macros](#19-macros)
20. [Type Casting](#20-type-casting)
21. [Nested Types](#21-nested-types)
22. [Extensions](#22-extensions)
23. [Protocols](#23-protocols)
24. [Generics](#24-generics)
25. [Opaque and Boxed Protocol Types](#25-opaque-and-boxed-protocol-types)
26. [Automatic Reference Counting](#26-automatic-reference-counting)
27. [Memory Safety](#27-memory-safety)
28. [Access Control](#28-access-control)
29. [Advanced Operators](#29-advanced-operators)

---

## 1. The Basics

Swift, type safe bir dildir. Her değerin tipi derleme anında bellidir ve tipler arasında örtük dönüşüm yapılmaz. Bu bölüm dilin temel yapı taşlarını kapsar: constant ve variable tanımı, sayısal tipler, tuple, optional ve hata yakalamaya yardımcı olan assertion'lar.

### Constants ve variables

`let` ile tanımlanan değer bir kez atanır, `var` ile tanımlanan değer sonradan değiştirilebilir. Varsayılan tercih her zaman `let` olmalıdır. Değerin değişmesi gerektiği ortaya çıktığında `var`'a geçilir.

```swift
let maxRetryCount = 3
var retryCount = 0

let defaultTimeout: TimeInterval = 30
var authToken: String?
```

`let` ile tanımlanan bir değerin ilk ataması tanımdan sonra da yapılabilir. Derleyici, her yolda tam olarak bir atama yapıldığını kontrol eder.

```swift
let isProduction = false

let apiHost: String
if isProduction {
    apiHost = "api.example.com"
} else {
    apiHost = "staging.api.example.com"
}
```

> [!IMPORTANT]
> `let` tercih edilmesinin asıl sebebi niyeti açık etmektir. Kodu okuyan kişi değerin değişmeyeceğini bilir, derleyici de yanlışlıkla yapılan atamayı yakalar. Value type'larda (struct, enum) `let` instance'ın tamamını değişmez kılar. Reference type'larda (class) ise yalnızca referansı sabitler, nesnenin içi değişebilir.

### Type annotation ve type inference

Swift tipi çoğu zaman atanan değerden çıkarır. Tip açıkça yazılması gereken üç durum vardır: ilk değer verilmediğinde, literal'ın çıkarılan tipi istenen tip olmadığında ve okunabilirlik gerektiğinde.

```swift
let pageSize = 20               // Int
let progress = 0.75             // Double, Float değil
let opacity: Float = 0.75       // Float isteniyorsa açıkça yazılır
let userIDs: [UUID] = []        // boş koleksiyonda tip çıkarılamaz
```

### Sayısal tipler

Tam sayılar için `Int` kullanılır. Değer negatif olamayacak olsa bile `UInt` tercih edilmez, çünkü API'lerin neredeyse tamamı `Int` bekler ve sürekli dönüşüm yapmak gerekir. `UInt` sadece bit işlemleri ve C kütüphaneleriyle çalışırken anlamlıdır. Ondalıklı sayılarda varsayılan `Double`'dır.

Swift tipler arasında örtük dönüşüm yapmaz. `Int` ile `Double` toplanacaksa biri açıkça dönüştürülür.

```swift
let totalItems = 7
let pageSize = 3

let fullPages = totalItems / pageSize                       // 2, kesirli kısım atılır
let exactPages = Double(totalItems) / Double(pageSize)      // 2.333...
let pageCount = (totalItems + pageSize - 1) / pageSize      // 3, yukarı yuvarlanmış sayfa sayısı
```

> [!WARNING]
> `Double(totalItems / pageSize)` yazmak `2.333` değil `2.0` verir. Parantez içindeki bölme önce `Int` olarak yapılır, kesirli kısım atılır, dönüşüm ondan sonra gelir. Dönüşüm bölmeden önce yapılmalıdır.

Para gibi kesin olması gereken değerlerde `Double` kullanılmaz. `Double` ikili tabanda saklandığı için `0.1` gibi değerleri tam temsil edemez. Bunun yerine `Decimal` kullanılır.

```swift
let a = 0.1 + 0.2
print(a == 0.3)                         // false
print(a)                                // 0.30000000000000004

let price = Decimal(string: "19.99")!
let total = price * 3
print(total)                            // 59.97
```

Büyük sayıları okumak için literal'larda alt çizgi kullanılabilir: `let maxUploadSize = 10_000_000`.

> [!CAUTION]
> Tam sayı taşması (overflow) Swift'te sessizce gerçekleşmez. Derleyici sabit değerlerdeki taşmayı (`Int.max + 1`) derleme anında yakalar. Çalışma anında hesaplanan bir değer taşarsa program crash olur. Bilinçli olarak taşma istenen durumlar için `&+` gibi overflow operatörleri vardır (bkz. [Advanced Operators](#29-advanced-operators)).

### Type aliases

`typealias` mevcut bir tipe ikinci bir isim verir. Yeni bir tip oluşturmaz, sadece okunabilirliği artırır.

```swift
typealias UserID = UUID
typealias CompletionHandler = (Result<Data, Error>) -> Void

func fetchAvatar(for id: UserID, completion: @escaping CompletionHandler) {
    // ...
}
```

### Booleans

Swift'te `Bool` dışında hiçbir tip koşul olarak kullanılamaz. C'deki gibi `if 1` ya da `if count` yazılmaz, koşul açıkça yazılır: `if count > 0`. Bool değişken isimleri bir soru gibi okunmalıdır: `isLoading`, `hasMorePages`, `canSubmit`, `shouldRetry`.

### Tuples

Tuple, birden fazla değeri geçici olarak bir arada taşır. En yaygın kullanımı bir fonksiyondan birden fazla değer döndürmektir. Elemanlara isim verilmesi okunabilirliği ciddi şekilde artırır.

```swift
func parseStatusLine(_ line: String) -> (code: Int, reason: String)? {
    let parts = line.split(separator: " ", maxSplits: 2)
    guard parts.count == 3, let code = Int(parts[1]) else { return nil }
    return (code, String(parts[2]))
}

if let status = parseStatusLine("HTTP/1.1 404 Not Found") {
    print(status.code)      // 404
    print(status.reason)    // Not Found
}

let (code, _) = parseStatusLine("HTTP/1.1 200 OK") ?? (0, "")
print(code)                 // 200
```

> [!TIP]
> Tuple geçici sonuçlar içindir. Değer birden fazla katmandan geçecekse, bir koleksiyonda saklanacaksa ya da bir protokole (`Codable`, `Equatable`, `Identifiable`) uyması gerekecekse struct'a çevrilmelidir. Tuple'lar protokollere uyamaz ve metot içeremez.

### Optionals

Optional, bir değerin olabileceğini ya da hiç olmayabileceğini ifade eder. `String?` tipi ya bir `String` taşır ya da `nil`'dir. Swift'te `nil`, sadece optional tiplere atanabilir. Bu sayede "bu değer yok olabilir mi?" sorusunun cevabı tipin kendisinde yazılıdır.

> [!IMPORTANT]
> Optional aslında standart kütüphanede tanımlı iki case'li bir enum'dur: `case none` ve `case some(Wrapped)`. `nil` yazmak `.none` yazmakla aynıdır. `if let`, `??` ve optional chaining bu enum üzerine kurulmuş söz dizimi kolaylıklarıdır.

Optional'ın içindeki değere erişmenin birkaç yolu vardır.

**if let.** Değer sadece bir dalın içinde lazımsa kullanılır. Swift 5.7'den itibaren aynı isimle açarken kısa yazım geçerlidir: `if let token`.

```swift
func makeRequest(path: String, token: String?) -> URLRequest? {
    guard let url = URL(string: "https://api.example.com" + path) else { return nil }

    var request = URLRequest(url: url)
    if let token {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
}
```

**guard let.** Fonksiyonun devam edebilmesi için değerin şart olduğu durumlarda kullanılır. Değer yoksa erken çıkılır, açılan değer fonksiyonun geri kalanında kullanılabilir. `else` bloğu kapsamdan mutlaka çıkmalıdır (`return`, `throw`, `break`, `continue` ya da `fatalError`).

```swift
struct SignUpForm {
    var email: String?
    var password: String?
    var acceptedTerms: Bool
}

enum SignUpError: Error {
    case missingEmail, weakPassword, termsNotAccepted
}

func validate(_ form: SignUpForm) throws -> (email: String, password: String) {
    guard let email = form.email, !email.isEmpty else { throw SignUpError.missingEmail }
    guard let password = form.password, password.count >= 8 else { throw SignUpError.weakPassword }
    guard form.acceptedTerms else { throw SignUpError.termsNotAccepted }
    return (email, password)
}
```

Bu örnekte koşullar birbirinin içine girmeden alt alta sıralanır. Her `guard` bir ön koşulu kontrol eder, mutlu yol (happy path) fonksiyonun en solunda ve en altında kalır.

> [!TIP]
> `if let` mi `guard let` mi? Açılan değer fonksiyonun geri kalanında lazımsa ve değer yokken devam etmenin anlamı yoksa `guard let`. Değer sadece bir dalda lazımsa ve yokluğu normal bir durumsa `if let`. İç içe birden fazla `if let` yazmaya başladıysan (pyramid of doom) `guard`'a geçmenin zamanı gelmiştir.

> [!WARNING]
> `if let` ve `guard let` sadece optional değerleri açar. `Bool` ya da optional olmayan bir değerle kullanılamaz. Bool kontrolü için düz koşul yazılır.
>
> ```swift
> func submit(acceptedTerms: Bool) {
>     // guard let acceptedTerms else { return }
>     // error: initializer for conditional binding must have Optional type, not 'Bool'
>     guard acceptedTerms else { return }
>     print("Submitting")
> }
> ```

**Birden fazla binding ve koşul.** Virgülle ayrılan her parça sırayla değerlendirilir ve biri başarısız olursa sonrakilere bakılmaz. Her binding kendi `let`'ini ister.

```swift
let userInfo: [String: Any] = ["id": 42, "name": "Ada"]

if let id = userInfo["id"] as? Int, let name = userInfo["name"] as? String, id > 0 {
    print("\(id): \(name)")
}
```

**Nil coalescing (`??`).** Değer yoksa varsayılan bir değer kullanılır. Sağ taraf sadece sol taraf `nil` olduğunda değerlendirilir.

```swift
let nickname: String? = nil
let fullName = "Ada Lovelace"
let displayName = nickname ?? fullName
```

**Force unwrap (`!`).** Değer `nil` ise program crash olur.

> [!CAUTION]
> Force unwrap sadece `nil` olmasının programcı hatası anlamına geldiği yerlerde kabul edilebilir. Kodun içine sabit yazılmış geçerli bir URL ya da uygulama paketine eklenmiş bir dosya bu duruma örnektir. Ağdan, kullanıcıdan ya da diskten gelen veride asla kullanılmaz. Crash mesajını anlamlı kılmak için `guard let ... else { preconditionFailure("...") }` daha iyi bir seçenektir.

**Implicitly unwrapped optional (`String!`).** Optional'dır ama her kullanımda otomatik olarak açılır. Değer `nil` iken erişilirse crash olur. Pratikte UIKit'teki `@IBOutlet` gibi, nesne oluşturulduktan hemen sonra atanan ve ondan sonra hiç `nil` olmayan değerler için kullanılır. Yeni kodda tercih edilmez.

> [!WARNING]
> Optional bir değeri string interpolation içine koymak `Optional("Ada")` gibi bir çıktı üretir ve derleyici uyarı verir. Önce açılmalı ya da `??` ile varsayılan verilmelidir.

### Error handling

Optional bir değerin yokluğunu ifade eder ama nedenini söylemez. Bir işlemin neden başarısız olduğu önemliyse fonksiyon `throws` olarak işaretlenir ve hata fırlatır. Konunun ayrıntısı [Error Handling](#17-error-handling) bölümündedir.

### Assertions ve preconditions

Bu fonksiyonlar, kodun doğru çalışması için mutlaka sağlanması gereken koşulları kontrol eder. Koşul sağlanmazsa program durur.

| Fonksiyon | Debug build | Release build | Kullanım |
|---|---|---|---|
| `assert` | Çalışır | Çalışmaz | Geliştirme sırasında iç tutarlılık kontrolü |
| `precondition` | Çalışır | Çalışır | Fonksiyonu çağıranın uyması gereken sözleşme |
| `fatalError` | Çalışır | Çalışır | Ulaşılmaması gereken kod, `init?(coder:)` gibi zorunlu ama desteklenmeyen yollar |

```swift
func page<T>(_ items: [T], number: Int, size: Int) -> ArraySlice<T> {
    precondition(number >= 0, "Page number must be non-negative")
    precondition(size > 0, "Page size must be positive")

    let start = number * size
    guard start < items.count else { return [] }
    return items[start..<min(start + size, items.count)]
}
```

> [!NOTE]
> Kullanıcının yanlış veri girmesi bir programcı hatası değildir. Bu tür durumlar `precondition` ile değil, optional ya da hata fırlatma ile ele alınır. Assertion'lar sadece "bu asla olmamalı" denen durumlar içindir.

### Mülakat soruları

<details>
<summary><b>let ile var arasındaki fark ne, varsayılan olarak hangisini kullanırsın ve neden?</b></summary>

`let` bir kez atanır, `var` değiştirilebilir. Varsayılan `let`'tir çünkü niyeti açık eder. Okuyan kişi değerin değişmeyeceğini bilir ve derleyici yanlışlıkla yapılan atamayı yakalar. Struct'larda `let` instance'ın tamamını değişmez yapar. Class'ta ise sadece referansı sabitler, nesnenin property'leri değişmeye devam edebilir.
</details>

<details>
<summary><b>Optional nedir, Swift'te nasıl tanımlanmıştır?</b></summary>

Bir değerin olabileceğini ya da olmayabileceğini ifade eden tiptir. Standart kütüphanede `none` ve `some(Wrapped)` case'lerine sahip generic bir enum olarak tanımlıdır. `nil` aslında `.none`'dır. Bu tasarım sayesinde bir değerin yok olabileceği bilgisi tip sisteminde yer alır ve derleyici, değer açılmadan kullanılmasını engeller.
</details>

<details>
<summary><b>if let ile guard let arasındaki fark ne, hangisini ne zaman seçersin?</b></summary>

`if let` ile açılan değer sadece o bloğun içinde geçerlidir. `guard let` ile açılan değer ise fonksiyonun geri kalanında kullanılabilir ve `else` bloğu kapsamdan çıkmak zorundadır. Fonksiyonun devam etmesi için değer şartsa `guard let` kullanırım. Böylece ön koşullar başta toplanır, iç içe bloklar oluşmaz ve asıl iş akışı girintisiz kalır. Değer sadece bir dalda lazımsa ve yokluğu normal bir durumsa `if let` kullanırım.
</details>

<details>
<summary><b>Force unwrap kullanmak ne zaman kabul edilebilir?</b></summary>

`nil` olmasının programcı hatası anlamına geldiği durumlarda. Kod içinde sabit yazılmış geçerli bir URL ya da uygulama paketindeki bir dosya buna örnektir. Ağdan, diskten ya da kullanıcıdan gelen veride kabul edilemez. Böyle durumlarda bile `guard let` ile `preconditionFailure` kullanmak crash mesajını daha anlamlı yapar.
</details>

<details>
<summary><b>assert, precondition ve fatalError arasındaki fark ne?</b></summary>

`assert` sadece debug build'de çalışır, geliştirme sırasında iç tutarlılığı kontrol etmek için kullanılır. `precondition` release build'de de çalışır ve fonksiyonu çağıranın uyması gereken sözleşmeyi korur. `fatalError` her koşulda programı durdurur ve ulaşılmaması gereken kod yolları için kullanılır.
</details>

<details>
<summary><b>Para tutarlarını neden Double ile tutmayız?</b></summary>

`Double` ikili tabanda saklandığı için `0.1` gibi ondalık değerleri tam temsil edemez. Küçük yuvarlama hataları toplama ve çarpma işlemleri boyunca birikir. Örneğin `0.1 + 0.2 == 0.3` ifadesi `false` döner. Para için `Decimal` ya da en küçük birim cinsinden `Int` (kuruş, cent) kullanılır.
</details>

<details>
<summary><b>Tuple ne zaman, struct ne zaman kullanılır?</b></summary>

Tuple, bir fonksiyondan birden fazla değer döndürmek gibi geçici ve yerel durumlar için uygundur. Değer birden fazla katmandan geçiyorsa, saklanıyorsa, davranış (metot) gerekiyorsa ya da bir protokole uyması gerekiyorsa struct kullanılır. Tuple'lar protokollere uyamaz, bu yüzden `Codable` ya da `Equatable` olamaz.
</details>

---

## 2. Basic Operators

Swift'in operatörleri C'ye benzer ama hataya yol açan davranışları kaldırılmıştır. Atama işlemi değer döndürmez, tam sayı taşması crash ile sonuçlanır, aralık operatörleri ise dilin bir parçasıdır.

### Assignment

Atama operatörü (`=`) değer döndürmez. Bu sayede `==` yerine yanlışlıkla `=` yazılan bir `if` koşulu derlenmez. Bileşik atama operatörleri (`+=`, `-=`, `*=`) de değer döndürmez, dönüş tipleri `Void`'dir.

```swift
var badgeCount = 3
badgeCount += 1
print(badgeCount)          // 4
```

> [!WARNING]
> `print(badgeCount += 1)` yazmak sayıyı değil `()` yazdırır. Bileşik atama bir değer üretmez. Önce işlem yapılır, sonra değişken ayrıca yazdırılır.

### Arithmetic ve remainder

`+`, `-`, `*`, `/` operatörleri aynı tipteki iki değer arasında çalışır. Tam sayı bölmesi kesirli kısmı atar. `%` kalan operatörüdür ve sonucun işareti soldaki sayının işaretini alır: `-7 % 3` sonucu `-1`'dir. `Double` için `%` yoktur, onun yerine `truncatingRemainder(dividingBy:)` kullanılır.

```swift
let elapsedSeconds = 3_725
let hours = elapsedSeconds / 3600
let minutes = (elapsedSeconds % 3600) / 60
let seconds = elapsedSeconds % 60
print("\(hours)h \(minutes)m \(seconds)s")     // 1h 2m 5s

let rowIndex = 14
let isEvenRow = rowIndex.isMultiple(of: 2)     // % 2 == 0 yerine daha okunaklı
```

### Comparison

`==`, `!=`, `<`, `>`, `<=`, `>=` her zaman `Bool` döndürür. Kendi tiplerin için `==` kullanabilmek için tipin `Equatable`'a, `<` kullanabilmek için `Comparable`'a uyması gerekir. Class instance'larında aynı nesne olup olmadığını kontrol etmek için `===` kullanılır (bkz. [Structures and Classes](#9-structures-and-classes)).

Tuple'lar, yedi elemandan azsa ve elemanları karşılaştırılabilirse soldan sağa doğru karşılaştırılır. Bu özellik çok kriterli sıralamada işe yarar.

```swift
struct Release {
    let major: Int
    let minor: Int
    let patch: Int
}

let releases = [
    Release(major: 2, minor: 1, patch: 0),
    Release(major: 1, minor: 9, patch: 3),
    Release(major: 2, minor: 0, patch: 7)
]

let sorted = releases.sorted { ($0.major, $0.minor, $0.patch) < ($1.major, $1.minor, $1.patch) }
print(sorted.map { "\($0.major).\($0.minor).\($0.patch)" })    // ["1.9.3", "2.0.7", "2.1.0"]
```

### Ternary conditional

`koşul ? a : b` kısa iki seçenekli ifadeler içindir. İç içe ternary yazılmaz, okunabilirlik hızla düşer.

```swift
let unreadCount = 1
let label = "\(unreadCount) " + (unreadCount == 1 ? "message" : "messages")
```

> [!WARNING]
> Ternary'nin önceliği `+` ve `==` operatörlerinden düşüktür. Yukarıdaki parantezler kaldırılırsa ifade `("\(unreadCount) " + unreadCount) == 1 ? ...` gibi yorumlanır ve derlenmez. Ternary başka bir ifadenin parçasıysa her zaman paranteze alınır.

### Nil-coalescing

`a ?? b`, `a` doluysa içindeki değeri, `nil` ise `b`'yi döndürür. `b` sadece gerektiğinde değerlendirilir, bu yüzden sağ tarafta pahalı bir işlem olması sorun yaratmaz. Zincirleme kullanılabilir: `cachedName ?? remoteName ?? "Guest"`.

### Range operators

| Operatör | Anlamı | Örnek |
|---|---|---|
| `a...b` | Closed range, `b` dahil | `1...5` → 1, 2, 3, 4, 5 |
| `a..<b` | Half-open range, `b` hariç | `0..<items.count` |
| `a...` / `...b` / `..<b` | One-sided range | `items[2...]`, `items[..<3]` |

Dizilerin index'leri sıfırdan başlayıp `count - 1`'de bittiği için half-open range doğal seçimdir. Ancak index üzerinde dönmek gerekiyorsa `0..<items.count` yerine `items.indices` kullanmak daha güvenlidir.

```swift
let notifications = ["Build passed", "PR approved", "Deploy started", "Deploy finished"]

for index in notifications.indices {
    print("\(index + 1). \(notifications[index])")
}

let latestTwo = notifications.suffix(2)
let firstTwo = notifications.prefix(2)
```

> [!CAUTION]
> Bir diziyi range ile kesmek `ArraySlice` döndürür ve bu slice orijinal dizinin index'lerini korur. `let tail = notifications[2...]` dedikten sonra `tail[0]` yazmak crash olur, çünkü `tail`'in ilk index'i `2`'dir. Slice üzerinde `first`, `startIndex` ya da `Array(tail)` dönüşümü kullanılır.

> [!CAUTION]
> Alt sınırı üst sınırdan büyük bir range oluşturmak (`5...3`) çalışma anında crash olur. Sınırlar hesaplanıyorsa önce kontrol edilmelidir.

### Logical operators

`!`, `&&`, `||` operatörleri `Bool` üzerinde çalışır ve short-circuit davranışı gösterir. `&&` ifadesinde sol taraf `false` ise sağ taraf hiç değerlendirilmez. Bu özellik güvenli kontrol yazmak için kullanılır.

```swift
let recentSearches: [String] = []

if !recentSearches.isEmpty && recentSearches[0].count > 2 {
    print("Suggest: \(recentSearches[0])")
}
```

Burada dizi boşsa `recentSearches[0]` ifadesine hiç ulaşılmaz. Sıra ters yazılsaydı boş dizide crash olurdu. Birden fazla `&&` ve `||` bir arada kullanılıyorsa, öncelik kurallarını bilmek yerine parantez kullanmak niyeti açıkça gösterir.

### Mülakat soruları

<details>
<summary><b>Swift'te atama operatörü neden değer döndürmez?</b></summary>

C'de `if (x = y)` gibi, `==` yerine yanlışlıkla `=` yazılan koşullar derlenir ve zor bulunan hatalara yol açar. Swift atamayı `Void` döndüren bir işlem yaparak bu hatayı derleme anında engeller.
</details>

<details>
<summary><b>Int taşması olduğunda Swift ne yapar, C'den farkı ne?</b></summary>

C'de işaretli tam sayı taşması tanımsız davranıştır ve program yanlış değerle çalışmaya devam edebilir. Swift'te taşma çalışma anında yakalanır ve program durur. Taşmanın bilinçli olarak istendiği durumlar (hash hesaplama gibi) için `&+`, `&-`, `&*` overflow operatörleri kullanılır.
</details>

<details>
<summary><b>Short-circuit evaluation nedir, pratikte nerede işine yarar?</b></summary>

`&&` ifadesinde sol taraf `false` ise, `||` ifadesinde sol taraf `true` ise sağ taraf hiç değerlendirilmez. Güvenli kontrol yazmak için kullanılır. `!items.isEmpty && items[0] == x` ifadesinde dizi boşsa index erişimine hiç ulaşılmaz. Ayrıca pahalı kontrolleri sağa koyarak gereksiz hesaplamadan kaçınılabilir.
</details>

<details>
<summary><b>Bir diziden aldığın slice'ın ilk elemanına neden [0] ile erişemezsin?</b></summary>

`ArraySlice`, orijinal dizinin belleğini paylaşır ve onun index'lerini korur. `array[3...]` ile alınan slice'ın ilk index'i `3`'tür, `0` değil. `slice[0]` crash olur. `slice.first`, `slice[slice.startIndex]` kullanılır ya da slice `Array(slice)` ile yeni bir diziye çevrilir.
</details>

---

## 3. Strings and Characters

Swift'te `String` bir value type'tır ve Unicode'u tam olarak destekler. Bu iki özellik, string'lerle çalışırken karşılaşılan alışılmadık kuralların (Int index olmaması, `count`'un maliyetli olması) sebebidir.

### Literals

Tek satırlık string'ler çift tırnakla yazılır. Çok satırlı metinler için üç tırnak kullanılır. Kapanış tırnağının girintisi, satırlardan ne kadar boşluk silineceğini belirler.

```swift
let query = """
    SELECT id, title
    FROM articles
    WHERE published = 1
    """
```

Ters bölü ve tırnak işaretlerinin çok olduğu metinlerde raw string kullanılır. `#"..."#` içinde kaçış karakterleri işlenmez. Interpolation için `\#(...)` yazılır.

```swift
let pattern = #"^\d{3}-\d{4}$"#
let field = "email"
let json = #"{"field": "\#(field)", "required": true}"#
print(json)     // {"field": "email", "required": true}
```

### Value semantics

String bir value type'tır. Bir değişkene atandığında ya da bir fonksiyona verildiğinde kopyalanır. Kopyalama işlemi copy on write sayesinde ucuzdur: gerçek kopya sadece iki taraftan biri değiştirildiğinde yapılır.

### Interpolation ve CustomStringConvertible

Bir tipin interpolation içinde nasıl görüneceği `CustomStringConvertible` protokolü ile belirlenir. Loglama ve hata mesajlarında oldukça kullanışlıdır.

```swift
struct HTTPError: Error, CustomStringConvertible {
    let statusCode: Int
    let path: String

    var description: String {
        "HTTP \(statusCode) at \(path)"
    }
}

let error = HTTPError(statusCode: 503, path: "/v1/orders")
print("Request failed: \(error)")      // Request failed: HTTP 503 at /v1/orders
```

### Unicode ve Character

Swift'te bir `Character`, ekranda tek karakter olarak görünen birimdir (extended grapheme cluster). Bu birim birden fazla Unicode scalar'dan oluşabilir. Bu yüzden aynı metin için farklı "uzunluklar" vardır.

```swift
let reaction = "👍🏽"
print(reaction.count)                   // 1, kullanıcının gördüğü karakter sayısı
print(reaction.unicodeScalars.count)    // 2, el + ten rengi
print(reaction.utf16.count)             // 4, NSString ve UIKit'in kullandığı birim
print(reaction.utf8.count)              // 8, byte cinsinden boyut
```

> [!TIP]
> Hangi uzunluk ne zaman kullanılır? Kullanıcıya gösterilen karakter limiti için `count`. `UITextField` delegate metotları ve `NSRange` ile çalışırken `utf16.count`, çünkü Foundation tarafı UTF-16 ile çalışır. Ağ üzerinden gönderilen veri ya da veritabanı alan boyutu için `utf8.count`.

### Index ve Substring

String'e `Int` ile erişilemez. Karakterler farklı byte uzunluklarında olabildiği için n'inci karaktere ulaşmak baştan saymayı gerektirir. Swift bu maliyeti gizlemek yerine `String.Index` tipi ile görünür kılar.

```swift
let trackingCode = "TR-2026-88412"

let firstChar = trackingCode[trackingCode.startIndex]                       // "T"
let fifth = trackingCode[trackingCode.index(trackingCode.startIndex, offsetBy: 4)]  // "0"

if let dash = trackingCode.firstIndex(of: "-") {
    let country = trackingCode[..<dash]                // "TR"
    print(country)
}
```

Pratikte doğrudan index ile uğraşmak yerine üst seviye API'ler tercih edilir: `prefix(_:)`, `suffix(_:)`, `dropFirst()`, `split(separator:)`, `hasPrefix(_:)`, `contains(_:)`.

String'den range ile alınan parça `Substring` tipindedir. `Substring`, orijinal string'in belleğini paylaşır ve kopyalama yapmaz. Bu sayede ayrıştırma (parsing) işlemleri hızlı çalışır.

```swift
struct LogEntry {
    let level: String
    let message: String
}

func parse(_ line: String) -> LogEntry? {
    let parts = line.split(separator: "|", maxSplits: 1)
    guard parts.count == 2 else { return nil }
    return LogEntry(
        level: String(parts[0]).trimmingCharacters(in: .whitespaces),
        message: String(parts[1]).trimmingCharacters(in: .whitespaces)
    )
}

print(parse("ERROR | Token expired")?.message ?? "-")    // Token expired
```

> [!IMPORTANT]
> `Substring` uzun süre saklanmamalıdır. Küçük bir parça bile tutulduğu sürece orijinal string'in tamamı bellekte kalır. Bir property'ye atanacak ya da başka bir katmana verilecekse `String(...)` ile yeni bir string'e çevrilir. Yukarıdaki `LogEntry` bu yüzden `String` saklar.

### Karşılaştırma ve arama

`==` iki string'i Unicode açısından eşdeğer olup olmadıklarına göre karşılaştırır. Örneğin "é" harfinin tek scalar ile yazılmış hali ile "e" ve aksan işaretinden oluşan hali eşit sayılır. Büyük küçük harf duyarlılığı ve dil kuralları için Foundation API'leri kullanılır.

```swift
let titles = ["Zebra", "apple", "Äpfel", "item 10", "item 2"]

let sortedForUser = titles.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
print(sortedForUser)    // ["Äpfel", "apple", "item 2", "item 10", "Zebra"]

let matches = titles.filter { $0.localizedStandardContains("APP") }
print(matches)          // ["apple"]
```

> [!TIP]
> Kullanıcıya gösterilen listeleri sıralarken `<` yerine `localizedStandardCompare` kullanılır. Bu fonksiyon büyük küçük harfi, aksanları ve sayıları Finder'daki gibi doğal sırayla ele alır ("item 2", "item 10"dan önce gelir). Arama kutularında `localizedStandardContains` aynı rolü üstlenir.

### Sık kullanılan işlemler

```swift
let input = "  Ada@Example.com \n"
let email = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
print(email)                                    // ada@example.com

let tags = "swift, ios ,  swiftui".split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
print(tags)                                     // ["swift", "ios", "swiftui"]

let slug = "Release Notes 2.1".lowercased().replacingOccurrences(of: " ", with: "-")
print(slug)                                     // release-notes-2.1
```

> [!TIP]
> Boşluk kontrolü için `count == 0` yerine `isEmpty` kullanılır. `isEmpty` sabit sürede çalışır, `count` ise tüm karakterleri saymak zorundadır.

### Sayı ve tarih biçimlendirme

Kullanıcıya gösterilen sayıları `String(format:)` ile biçimlendirmek hem C tarzı format hatalarına açıktır hem de kullanıcının bölge ayarlarını hesaba katmaz. Modern Foundation'da `formatted()` kullanılır.

```swift
let amount = Decimal(string: "1249.5")!
print(amount.formatted(.currency(code: "TRY").locale(Locale(identifier: "tr_TR"))))   // ₺1.249,50

let ratio = 0.873
print(ratio.formatted(.percent.precision(.fractionLength(1))))
```

### Mülakat soruları

<details>
<summary><b>Swift'te bir String'e neden Int ile index veremeyiz?</b></summary>

Swift'te bir karakter, birden fazla Unicode scalar'dan oluşabilir ve bellekte farklı uzunluklarda yer kaplar. Bu yüzden n'inci karaktere ulaşmak baştan saymayı gerektirir, yani O(n) bir işlemdir. Int subscript bu maliyeti O(1) gibi gösterirdi. Swift bunun yerine `String.Index` tipini kullanarak maliyeti görünür kılar.
</details>

<details>
<summary><b>Substring neden var, ne zaman String'e çevirirsin?</b></summary>

Substring orijinal string'in belleğini paylaşır ve kopyalama yapmaz, bu yüzden parsing gibi işlemler hızlıdır. Ancak tutulduğu sürece orijinal string'in tamamını bellekte tutar. Kısa süreli işlemlerde Substring ile çalışırım. Bir property'ye atanacak, saklanacak ya da başka bir katmana verilecekse `String(...)` ile çeviririm.
</details>

<details>
<summary><b>"👍🏽".count kaç döner, unicodeScalars.count kaç döner, neden?</b></summary>

`count` 1 döner, çünkü kullanıcı tek bir karakter görür. `unicodeScalars.count` 2 döner, çünkü bu emoji bir el scalar'ı ile bir ten rengi scalar'ından oluşur. Swift'te `Character` tek scalar değil, ekranda tek karakter olarak görünen bir birimdir (extended grapheme cluster).
</details>

<details>
<summary><b>String bir value type. Büyük bir string'i fonksiyona vermek pahalı mı?</b></summary>

Değil. String copy on write kullanır. Kopyalama sırasında içerik kopyalanmaz, iki değişken aynı depolama alanını paylaşır. Gerçek kopya ancak taraflardan biri değiştirildiğinde yapılır.
</details>

<details>
<summary><b>isEmpty ile count == 0 arasında fark var mı?</b></summary>

Sonuç aynıdır ama maliyet farklıdır. `isEmpty` sabit sürede çalışır. String'de `count` ise tüm karakterleri saymak zorunda olduğu için O(n)'dir. Bu yüzden boşluk kontrolünde her zaman `isEmpty` kullanılır.
</details>

---

## 4. Collection Types

Swift'in üç temel koleksiyonu vardır: `Array`, `Set` ve `Dictionary`. Üçü de generic'tir, sadece tek tipte eleman tutar ve value type'tır. Kopyalama copy on write ile ucuz hale getirilmiştir.

### Hangisini seçmeli

| İhtiyaç | Koleksiyon | Neden |
|---|---|---|
| Sıra önemli, tekrar olabilir | `Array` | Index ile O(1) erişim, sıra korunur |
| Her eleman bir kez, hızlı "var mı?" kontrolü | `Set` | `contains` O(1), elemanlar `Hashable` olmalı |
| Bir anahtar ile değere erişim | `Dictionary` | Anahtar ile O(1) erişim, anahtarlar `Hashable` olmalı |

### Array

```swift
var recentSearches: [String] = []
recentSearches.append("swift concurrency")
recentSearches.insert("actors", at: 0)
recentSearches.append(contentsOf: ["sendable", "async let"])

print(recentSearches.count)               // 4
print(recentSearches.first ?? "none")     // actors

recentSearches.removeAll { $0.hasPrefix("async") }
```

Sık kullanılan API'ler:

| API | Açıklama |
|---|---|
| `first`, `last` | Optional property, dizi boşsa `nil`. Parantez almaz |
| `isEmpty`, `count` | Property, parantez almaz |
| `contains(_:)`, `contains(where:)` | Eleman var mı |
| `firstIndex(of:)`, `firstIndex(where:)` | Eşleşen ilk index, optional |
| `removeAll(where:)` | Koşula uyanları siler |
| `enumerated()` | `(offset, element)` çiftleri |
| `sorted()`, `sorted(by:)` | Sıralanmış yeni dizi döndürür |
| `sort()`, `sort(by:)` | Diziyi yerinde sıralar |

> [!WARNING]
> `count`, `first`, `last` ve `isEmpty` metot değil property'dir. `items.count()` yazmak derlenmez.

> [!CAUTION]
> `items[0]` dizi boşsa crash olur. Var olmayabilecek elemanlara `first`, `last` ya da `indices.contains(index)` kontrolü ile erişilir.

`append` ortalamada O(1)'dir. Dizinin başına ya da ortasına ekleme ve silme ise O(n)'dir, çünkü sonraki elemanların kaydırılması gerekir. Eleman sayısı önceden biliniyorsa `reserveCapacity(_:)` ile tekrar tekrar bellek ayırmanın önüne geçilebilir.

### Set

Set, sırasız ve tekrarsız bir koleksiyondur. Elemanların `Hashable` olması gerekir. Asıl gücü `contains` işleminin sabit sürede çalışmasıdır.

```swift
let blockedUserIDs: Set<Int> = [12, 98, 455]
let commentAuthorIDs = [7, 12, 33, 455, 801]

let visibleAuthors = commentAuthorIDs.filter { !blockedUserIDs.contains($0) }
print(visibleAuthors)        // [7, 33, 801]
```

> [!TIP]
> Bir döngü içinde bir dizi üzerinde `contains` çağrılıyorsa toplam maliyet O(n × m) olur. Aranan koleksiyonu önce `Set`'e çevirmek maliyeti O(n + m)'ye düşürür. Binlerce elemanlı listelerde bu fark kullanıcı tarafından hissedilir.

Set işlemleri iki kümeyi karşılaştırmak için kullanılır. Aşağıdaki örnekte bir kullanıcının sahip olduğu yetkiler ile bir ekranın gerektirdiği yetkiler karşılaştırılıyor.

```swift
let granted: Set = ["read", "comment", "upload"]
let required: Set = ["read", "upload", "delete"]

let all = granted.union(required)                  // read, comment, upload, delete
let common = granted.intersection(required)        // read, upload
let missing = required.subtracting(granted)        // delete, eksik olan yetki
let exclusive = granted.symmetricDifference(required)  // comment, delete
let canOpen = required.isSubset(of: granted)       // false
```

| İşlem | Sonuç |
|---|---|
| `a.union(b)` | İki kümedeki tüm elemanlar |
| `a.intersection(b)` | Sadece iki kümede de olanlar |
| `a.subtracting(b)` | `a`'da olup `b`'de olmayanlar |
| `a.symmetricDifference(b)` | Sadece birinde olanlar, ortak olanlar hariç |
| `a.isSubset(of: b)` | `a`'nın tüm elemanları `b`'de var mı |

> [!NOTE]
> Set'te elemanların sırası garanti edilmez ve programın her çalıştırılmasında değişebilir. Ekranda gösterilecekse önce `sorted()` ile diziye çevrilir.

### Dictionary

Dictionary, anahtar ile değer eşleştirir. Anahtarın `Hashable` olması gerekir. Subscript ile okuma her zaman optional döner, çünkü anahtarın sözlükte olup olmadığı derleme anında bilinemez.

```swift
var headers: [String: String] = [
    "Content-Type": "application/json",
    "Accept-Language": "tr-TR"
]

headers["Authorization"] = "Bearer abc123"     // ekleme ya da güncelleme
headers["Accept-Language"] = nil               // anahtarı siler

if let contentType = headers["Content-Type"] {
    print(contentType)
}

for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
    print("\(key): \(value)")
}
```

Varsayılan değerli subscript, sayma ve gruplama işlerini sadeleştirir.

```swift
let events = ["login", "purchase", "login", "logout", "login"]

var counts: [String: Int] = [:]
for event in events {
    counts[event, default: 0] += 1
}
print(counts["login"] ?? 0)      // 3
```

Bir diziden sözlük oluşturmak için iki hazır initializer vardır.

```swift
struct Order {
    let id: Int
    let customerID: Int
    let total: Decimal
}

let orders = [
    Order(id: 1, customerID: 10, total: 120),
    Order(id: 2, customerID: 11, total: 80),
    Order(id: 3, customerID: 10, total: 45)
]

let ordersByCustomer = Dictionary(grouping: orders, by: \.customerID)
print(ordersByCustomer[10]?.count ?? 0)          // 2

let ordersByID = Dictionary(uniqueKeysWithValues: orders.map { ($0.id, $0) })
print(ordersByID[3]?.total ?? 0)                 // 45
```

> [!CAUTION]
> `Dictionary(uniqueKeysWithValues:)` aynı anahtar iki kez gelirse crash olur. Anahtarların benzersiz olduğundan emin değilsen `Dictionary(_:uniquingKeysWith:)` kullanılır ve çakışmada hangi değerin kalacağı belirtilir: `Dictionary(pairs, uniquingKeysWith: { _, latest in latest })`.

> [!NOTE]
> Dictionary'de de sıra garanti edilmez. Sabit bir sırayla göstermek gerekiyorsa anahtarlar ya da çiftler sıralanır.

### Value semantics

Üç koleksiyon da value type'tır. Bir diziyi başka bir değişkene atamak ya da fonksiyona vermek bağımsız bir kopya oluşturur. Kopya üzerinde yapılan değişiklik orijinali etkilemez.

```swift
var draft = ["Intro", "Setup"]
let published = draft
draft.append("Advanced")

print(published.count)    // 2
print(draft.count)        // 3
```

Bu kopyalama copy on write sayesinde ucuzdur. `published` ve `draft` ilk başta aynı belleği paylaşır. `draft` değiştirildiği anda gerçek kopya yapılır.

> [!IMPORTANT]
> `let` ile tanımlanan bir koleksiyon tamamen değişmezdir. Eleman eklenemez, silinemez, değiştirilemez. Bu durum sadece Swift'in kendi koleksiyonları için geçerlidir. Class tipindeki elemanları tutan `let` bir dizide, dizinin kendisi değişmez ama içindeki nesnelerin property'leri değiştirilebilir.

### Mülakat soruları

<details>
<summary><b>Array, Set ve Dictionary arasında nasıl seçim yaparsın?</b></summary>

Sıra önemliyse ya da aynı eleman birden fazla kez olabiliyorsa `Array`. Elemanlar benzersizse ve sık sık "bu eleman var mı?" diye soruluyorsa `Set`, çünkü `contains` O(1)'dir. Değere bir anahtar üzerinden erişiliyorsa `Dictionary`. Örneğin engellenen kullanıcı ID'leri `Set`, ID'ye göre önbelleğe alınmış kullanıcılar `Dictionary`, ekranda gösterilen sıralı liste `Array` olur.
</details>

<details>
<summary><b>Hashable ne demek, Set ve Dictionary neden buna ihtiyaç duyar?</b></summary>

`Hashable` bir değerin tam sayı bir hash değeri üretebildiği anlamına gelir. Set ve Dictionary elemanları bu hash değerine göre yerleştirir. Böylece arama, tüm elemanları dolaşmak yerine doğrudan ilgili konuma bakarak sabit sürede yapılır. Eşit iki değer aynı hash'i üretmek zorundadır. Bu yüzden `Hashable`, `Equatable`'ı da gerektirir. Struct ve enum'larda tüm property'ler `Hashable` ise uyum otomatik sentezlenir.
</details>

<details>
<summary><b>Copy on write nedir?</b></summary>

Value type koleksiyonlar kopyalandığında içerik hemen kopyalanmaz. İki değişken aynı depolama alanını paylaşır. Taraflardan biri değiştirilmek istendiğinde depolama alanının başka biri tarafından paylaşılıp paylaşılmadığı kontrol edilir. Paylaşılıyorsa gerçek kopya o anda yapılır. Bu sayede value semantics korunur ve gereksiz kopyalama maliyeti ödenmez.
</details>

<details>
<summary><b>Dictionary subscript'i neden optional döner?</b></summary>

Verilen anahtarın sözlükte olup olmadığı derleme anında bilinemez. Swift, anahtar yokken crash olmak ya da anlamsız bir varsayılan değer döndürmek yerine bu belirsizliği tipe yansıtır. Varsayılan değer isteniyorsa `dict[key, default: value]` ya da `dict[key] ?? value` kullanılır.
</details>

<details>
<summary><b>array.first ile array[0] arasındaki fark ne?</b></summary>

`first` optional döner ve dizi boşsa `nil` olur. `array[0]` ise dizi boşsa crash olur. Dizinin boş olmadığı garanti değilse `first` kullanılır.
</details>

<details>
<summary><b>Bir listeyi filtrelerken içerde başka bir dizide contains çağırıyorsun. Liste büyüyünce yavaşlıyor. Ne yaparsın?</b></summary>

Dizide `contains` O(n)'dir. Dış döngüyle birlikte toplam maliyet O(n × m) olur. İçerde aranan diziyi bir kez `Set`'e çeviririm. Böylece her `contains` O(1) olur ve toplam maliyet O(n + m)'ye iner.
</details>
