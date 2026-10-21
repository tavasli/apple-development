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

---

## 5. Control Flow

Swift'te akış kontrolü C'ye benzer ama daha güvenlidir. `switch` tüm durumları kapsamak zorundadır, case'ler arasında örtük geçiş (implicit fallthrough) yoktur. `if` ve `switch` değer üreten ifadeler olarak da kullanılabilir.

### for-in

`for-in` diziler, range'ler, sözlükler ve `Sequence` protokolüne uyan her tip üzerinde çalışır. Döngüye `where` ile filtre eklenebilir.

```swift
struct Member {
    let name: String
    let isActive: Bool
}

let members = [Member(name: "Ada", isActive: true), Member(name: "Linus", isActive: false)]

for member in members where member.isActive {
    print("Sending invite to \(member.name)")
}
```

Belirli adımlarla ilerlemek için `stride` kullanılır. Aşağıdaki örnek bir listeyi sabit boyutlu parçalar halinde işler. Toplu yükleme ya da API'nin tek seferde kabul ettiği kayıt sınırı gibi durumlarda bu kalıp sık görülür.

```swift
let photoIDs = Array(1...10)
let batchSize = 4

for start in stride(from: 0, to: photoIDs.count, by: batchSize) {
    let end = min(start + batchSize, photoIDs.count)
    print("Uploading \(Array(photoIDs[start..<end]))")
}
// Uploading [1, 2, 3, 4]
// Uploading [5, 6, 7, 8]
// Uploading [9, 10]
```

`stride(from:to:by:)` bitiş değerini dahil etmez, `stride(from:through:by:)` dahil eder.

İki diziyi eleman eleman eşleştirmek için `zip`, sıra numarası ile birlikte dolaşmak için `enumerated()` kullanılır.

```swift
let fields = ["email", "password"]
let messages = ["Invalid format", "Too short"]

for (field, message) in zip(fields, messages) {
    print("\(field): \(message)")
}

for (offset, field) in fields.enumerated() {
    print("\(offset + 1). \(field)")
}
```

> [!WARNING]
> `enumerated()` index değil sıra numarası (offset) üretir ve her zaman sıfırdan başlar. Bir `ArraySlice` üzerinde bu sayı ile subscript yapmak yanlış elemana ya da crash'e götürür. Gerçek index lazımsa `zip(slice.indices, slice)` kullanılır.

Optional elemanlardan oluşan bir dizide sadece dolu olanları dolaşmak için `for case let` kalıbı kullanılır.

```swift
let avatarURLs: [String?] = ["a.png", nil, "c.png"]

for case let url? in avatarURLs {
    print("Prefetching \(url)")
}
```

### while ve repeat-while

Kaç kez döneceği önceden bilinmeyen döngülerde `while` kullanılır. Koşul her turun başında kontrol edilir.

```swift
var attempt = 0
var delay = 0.5
let maxAttempts = 4

while attempt < maxAttempts {
    attempt += 1
    print("Attempt \(attempt), next delay \(delay)s")
    delay *= 2
}
```

`repeat-while` gövdeyi en az bir kez çalıştırır, koşulu turun sonunda kontrol eder. Cursor tabanlı sayfalamada ilk sayfa her zaman istendiği için doğal bir seçimdir.

```swift
func fetchPage(after cursor: Int?) -> (items: [String], nextCursor: Int?) {
    switch cursor {
    case nil: return (["a", "b"], 2)
    case 2?: return (["c", "d"], 4)
    default: return (["e"], nil)
    }
}

var cursor: Int? = nil
var allItems: [String] = []

repeat {
    let page = fetchPage(after: cursor)
    allItems += page.items
    cursor = page.nextCursor
} while cursor != nil

print(allItems)    // ["a", "b", "c", "d", "e"]
```

### if

Swift 5.9'dan itibaren `if` ve `switch` bir değer üreten ifade (expression) olarak kullanılabilir. Her dal tek bir ifade içermeli ve tüm dallar aynı tipte değer üretmelidir. Bu kullanım, sadece atama yapmak için `var` tanımlayıp sonra dallarda doldurmanın önüne geçer.

```swift
let itemCount = 3
let subtitle = if itemCount == 0 { "Your cart is empty" } else { "\(itemCount) items in cart" }
print(subtitle)
```

### switch

`switch`, bir değeri sırayla case'lerle karşılaştırır ve eşleşen ilk case'i çalıştırır. Swift'teki `switch` C'dekinden çok daha güçlüdür:

- Tüm olası değerler kapsanmalıdır (exhaustive). Kapsanmayan durum varsa kod derlenmez.
- Bir case bittiğinde bir sonrakine geçilmez, `break` yazmaya gerek yoktur.
- Bir case'te birden fazla değer virgülle yazılabilir.
- Range, tuple, enum case'i, tip kontrolü gibi pattern'ler kullanılabilir.

```swift
func category(for statusCode: Int) -> String {
    switch statusCode {
    case 200..<300: "Success"
    case 401, 403: "Authorization"
    case 429: "Rate limited"
    case 400..<500: "Client error"
    case 500...: "Server error"
    default: "Unexpected"
    }
}

print(category(for: 403))    // Authorization
print(category(for: 404))    // Client error
```

Case'ler yukarıdan aşağıya kontrol edildiği için özel durumlar genel durumlardan önce yazılır. `403` case'i `400..<500`'den sonra yazılsaydı hiçbir zaman çalışmazdı.

**Tuple ile switch.** Birden fazla değere aynı anda bakmak gerektiğinde değerler bir tuple'da toplanır. `_` herhangi bir değerle eşleşir.

```swift
enum Plan {
    case free, pro, team
}

func uploadLimitInMB(isVerified: Bool, plan: Plan) -> Int {
    switch (isVerified, plan) {
    case (false, _): 10
    case (true, .free): 100
    case (true, .pro), (true, .team): 1_000
    }
}
```

Bu fonksiyonda `default` yoktur ve buna gerek de yoktur. `Bool` ve `Plan` değerlerinin tüm kombinasyonları kapsanmıştır.

**Value binding ve where.** Eşleşen değerin bir kısmı `let` ile isimlendirilip case içinde kullanılabilir. `where` ek bir koşul ekler.

```swift
let response: (statusCode: Int, retryAfter: Int?) = (429, 30)

switch response {
case (429, let seconds?):
    print("Rate limited, retry in \(seconds)s")
case (let code, _) where code >= 500:
    print("Server error \(code), retry with backoff")
case (let code, _):
    print("Finished with \(code)")
}
```

> [!TIP]
> Kendi enum'ların üzerinde `switch` yazarken `default` kullanmaktan kaçınılır. Tüm case'ler açıkça yazılırsa, enum'a yeni bir case eklendiğinde derleyici güncellenmesi gereken her `switch`'i hata olarak gösterir. `default` yazıldığında yeni case sessizce oraya düşer.

`fallthrough` C'deki davranışı bilinçli olarak geri getirir ama gerçek projelerde nadiren gerekir. Aynı işi yapan değerler genellikle tek case'te virgülle birleştirilir.

### Control transfer

| İfade | Etkisi |
|---|---|
| `continue` | Döngünün bu turunu bitirir, sonraki tura geçer |
| `break` | Döngüden ya da `switch`'ten çıkar |
| `fallthrough` | `switch`'te bir sonraki case'e geçer |
| `return` | Fonksiyondan çıkar |
| `throw` | Hata fırlatarak kapsamdan çıkar |

İç içe döngülerde `break` sadece en içteki döngüden çıkar. Dıştaki döngüden çıkmak için döngüye etiket verilir.

```swift
let weeklySlots = [["09:00", "10:00"], ["11:00", "13:00"], ["13:00", "15:00"]]
var firstMatch: (day: Int, slot: String)?

search: for (day, slots) in weeklySlots.enumerated() {
    for slot in slots where slot == "13:00" {
        firstMatch = (day, slot)
        break search
    }
}

print(firstMatch?.day ?? -1)    // 1
```

### Early exit

`guard`, bir koşul sağlanmazsa kapsamdan erken çıkmak için kullanılır. Fonksiyonlarda nasıl kullanıldığı [The Basics](#1-the-basics) bölümünde anlatıldı. Döngü içinde `guard` ile `continue` birlikte kullanılarak geçersiz elemanlar atlanır.

```swift
let rawPrices = ["12.5", "abc", "", "40"]
var prices: [Double] = []

for raw in rawPrices {
    guard let price = Double(raw) else { continue }
    prices.append(price)
}
print(prices)    // [12.5, 40.0]
```

### defer

`defer` bloğu, içinde bulunduğu kapsamdan nasıl çıkılırsa çıkılsın (`return`, `throw`, `break` ya da kapsamın sonu) çıkış anında çalışır. Temizlik işlemlerini, işi başlatan kodun hemen yanına yazmayı sağlar. Böylece fonksiyona sonradan yeni bir `return` eklense bile temizlik atlanmaz.

```swift
enum FeedError: Error {
    case offline
}

final class FeedLoader {
    private(set) var isLoading = false
    var isOnline = false

    func load() throws -> [String] {
        isLoading = true
        defer { isLoading = false }

        guard isOnline else { throw FeedError.offline }
        return ["Post 1", "Post 2"]
    }
}

let loader = FeedLoader()
do {
    _ = try loader.load()
} catch {
    print(error, loader.isLoading)    // offline false
}
```

Aynı kapsamda birden fazla `defer` varsa ters sırayla çalışırlar: en son yazılan ilk çalışır. Bu sıra, kaynakları açıldıkları sıranın tersine kapatmak için uygundur.

> [!NOTE]
> Gerçek projelerdeki tipik `defer` kullanımları: loading durumunu sıfırlamak, bir kilidi bırakmak (`lock.unlock()`), açılan dosyayı kapatmak, `UIApplication.endBackgroundTask` çağırmak, test sonunda geçici dosyayı silmek.

### Availability

Bir API sadece belirli işletim sistemi sürümlerinde varsa, kullanmadan önce sürüm kontrolü yapılır. Derleyici bu kontrolü zorunlu tutar.

```swift
func configureAppearance() {
    if #available(iOS 17, macOS 14, *) {
        print("Use the new API")
    } else {
        print("Fall back to the old API")
    }
}

@available(iOS 17, macOS 14, *)
func makeModernLayout() {
    print("Only callable on iOS 17 and later")
}
```

`*` işareti, listede adı geçmeyen platformlarda minimum deployment target'ın geçerli olduğunu belirtir. Ters kontrol için `if #unavailable(iOS 17)` yazılır.

### Mülakat soruları

<details>
<summary><b>Swift'teki switch, C'deki switch'ten nasıl farklıdır?</b></summary>

Swift'te `switch` tüm durumları kapsamak zorundadır, aksi halde derlenmez. Case'ler arasında örtük geçiş yoktur, bu yüzden `break` unutmaktan kaynaklanan hatalar oluşmaz. Sadece tam sayılarla değil her tiple çalışır ve range, tuple, enum associated value, tip kontrolü gibi pattern'leri destekler. `let` ile değer bağlanabilir, `where` ile ek koşul eklenebilir.
</details>

<details>
<summary><b>Kendi enum'unun switch'inde neden default kullanmaktan kaçınırsın?</b></summary>

Tüm case'leri açıkça yazarsam, enum'a yeni bir case eklendiğinde derleyici o enum'u kullanan her `switch`'i hata olarak gösterir ve hiçbir yer gözden kaçmaz. `default` yazarsam yeni case sessizce varsayılan dala düşer ve hata ancak çalışma anında fark edilir.
</details>

<details>
<summary><b>defer ne zaman çalışır? Birden fazla defer olursa sıra nedir?</b></summary>

`defer` bloğu, içinde tanımlandığı kapsamdan çıkılırken çalışır. Çıkışın `return`, `throw` ya da kapsamın sonu olması fark etmez. Birden fazla `defer` varsa ters sırayla çalışırlar, en son tanımlanan ilk çalışır. Tipik kullanımı temizliktir: loading durumunu sıfırlamak, kilidi bırakmak, dosyayı kapatmak.
</details>

<details>
<summary><b>while ile repeat-while arasındaki fark ne, gerçek bir kullanım örneği verir misin?</b></summary>

`while` koşulu turun başında kontrol eder, koşul baştan sağlanmazsa gövde hiç çalışmaz. `repeat-while` koşulu sonda kontrol eder, gövde en az bir kez çalışır. Cursor tabanlı sayfalama iyi bir örnektir. İlk sayfa her zaman istenir, sonraki sayfalar ise cevaptaki cursor dolu olduğu sürece istenir.
</details>

<details>
<summary><b>İç içe iki döngüde, içteki döngüden dıştakini nasıl sonlandırırsın?</b></summary>

Dıştaki döngüye bir etiket veririm (`search: for ...`) ve içeride `break search` yazarım. Etiketsiz `break` sadece en içteki döngüden çıkar.
</details>

---

## 6. Functions

Fonksiyonlar Swift'te first class değerlerdir. Bir değişkene atanabilir, parametre olarak verilebilir ve başka bir fonksiyondan döndürülebilir. Swift'in fonksiyon söz dizimi, çağrıldığı yerde bir İngilizce cümle gibi okunacak şekilde tasarlanmıştır.

### Argument label ve parameter name

Her parametrenin iki adı vardır. Argument label, fonksiyon çağrılırken yazılır. Parameter name ise fonksiyonun gövdesinde kullanılır. Tek bir ad yazılırsa ikisi aynı olur. Label'ı kaldırmak için `_` kullanılır.

```swift
struct Account {
    var balance: Decimal
}

func transfer(_ amount: Decimal, from source: inout Account, to destination: inout Account) {
    source.balance -= amount
    destination.balance += amount
}

var checking = Account(balance: 500)
var savings = Account(balance: 100)
transfer(150, from: &checking, to: &savings)
print(checking.balance, savings.balance)    // 350 250
```

Çağrı noktası "transfer 150 from checking to savings" diye okunur. Gövdede ise `source` ve `destination` gibi anlamı daha açık isimler kullanılır.

> [!TIP]
> Swift API Design Guidelines'ın temel kuralları:
> - Çağrı noktasında okunabilirlik, tanımın kısalığından önemlidir.
> - İlk argüman fonksiyon adıyla birlikte doğal bir ifade oluşturuyorsa label kaldırılır: `print(_:)`, `append(_:)`, `contains(_:)`.
> - Argümanın rolünü bir edat anlatıyorsa label olarak edat kullanılır: `remove(at:)`, `move(from:to:)`, `fetchUser(withID:)`.
> - Yan etkisi olan fonksiyonlar fiil (`sort()`), yeni değer döndürenler isim ya da sıfat fiil (`sorted()`) olarak adlandırılır.

### Default parameter values

Varsayılan değerler, aynı fonksiyonun birçok overload'unu yazma ihtiyacını ortadan kaldırır. Varsayılan değerli parametreler genellikle listenin sonuna yazılır.

```swift
enum SortOrder {
    case newest, mostPopular
}

func fetchArticles(page: Int = 1, pageSize: Int = 20, sort: SortOrder = .newest) -> String {
    "page=\(page)&size=\(pageSize)&sort=\(sort)"
}

print(fetchArticles())                          // page=1&size=20&sort=newest
print(fetchArticles(page: 3))                   // page=3&size=20&sort=newest
print(fetchArticles(sort: .mostPopular))        // page=1&size=20&sort=mostPopular
```

### Variadic parameters

Variadic parametre, aynı tipte sıfır ya da daha fazla değer kabul eder. Fonksiyonun içinde bir dizi olarak görünür.

```swift
enum LogLevel: String {
    case debug, info, error
}

func log(_ messages: String..., level: LogLevel = .info) {
    print("[\(level.rawValue.uppercased())] " + messages.joined(separator: " "))
}

log("User", "42", "signed in")                  // [INFO] User 42 signed in
log("Token refresh failed", level: .error)      // [ERROR] Token refresh failed
```

### In-out parameters

Parametreler varsayılan olarak sabittir, fonksiyon içinde değiştirilemez. Bir parametrenin değişikliğinin çağıran tarafa yansıması isteniyorsa `inout` kullanılır ve çağrılırken başına `&` konur. Yukarıdaki `transfer` fonksiyonu buna örnektir.

`inout` referans geçirme değildir, copy in copy out olarak çalışır. Değer fonksiyona kopyalanır, fonksiyon bitince değiştirilmiş hali orijinal değişkene geri yazılır. Bu yüzden `inout` argüman olarak sadece `var` verilebilir. `let` sabitler ve literal'lar verilemez.

> [!TIP]
> `inout` yerine çoğu zaman yeni değer döndürmek daha okunaklıdır. `inout`, standart kütüphanedeki `swap(_:_:)` gibi bir değeri yerinde değiştiren yardımcı fonksiyonlarda ya da büyük bir struct'ı kopyalamadan güncellemek gerektiğinde tercih edilir.

### Return values

Gövdesi tek bir ifadeden oluşan fonksiyonlarda `return` yazılmayabilir (implicit return). Birden fazla değer döndürmek için tuple, sonuç olmayabiliyorsa optional dönüş tipi kullanılır.

```swift
func priceRange(of prices: [Decimal]) -> (min: Decimal, max: Decimal)? {
    guard let low = prices.min(), let high = prices.max() else { return nil }
    return (low, high)
}

if let range = priceRange(of: [49.9, 19.9, 120]) {
    print("\(range.min) - \(range.max)")    // 19.9 - 120
}
```

Dönüş değeri çoğu zaman kullanılmayan fonksiyonlar `@discardableResult` ile işaretlenir. Böylece sonuç kullanılmadığında derleyici uyarı vermez.

```swift
final class Cache {
    private var storage: [String: Data] = [:]

    @discardableResult
    func removeValue(forKey key: String) -> Data? {
        storage.removeValue(forKey: key)
    }
}

let cache = Cache()
cache.removeValue(forKey: "avatar")
```

Hiçbir zaman normal şekilde geri dönmeyen fonksiyonların dönüş tipi `Never`'dır. `fatalError` bu şekilde tanımlanmıştır. Derleyici `Never` döndüren bir çağrıdan sonra kodun devam etmeyeceğini bilir.

### Function types

Her fonksiyonun parametre ve dönüş tiplerinden oluşan bir tipi vardır. `(String) -> String?` "String alıp optional String döndüren fonksiyon" demektir. Fonksiyonlar bu tip üzerinden değişkene atanabilir, parametre olarak verilebilir ve döndürülebilir.

Aşağıdaki örnekte form doğrulama kuralları birer fonksiyon olarak tanımlanıyor. Kurallar bir dizide toplanıyor ve sırayla uygulanıyor.

```swift
typealias Validator = (String) -> String?

func notEmpty(_ value: String) -> String? {
    value.isEmpty ? "This field is required" : nil
}

func minLength(_ length: Int) -> Validator {
    { value in
        value.count >= length ? nil : "Must be at least \(length) characters"
    }
}

let passwordRules: [Validator] = [notEmpty, minLength(8)]
let errors = passwordRules.compactMap { rule in rule("abc") }
print(errors)    // ["Must be at least 8 characters"]
```

`minLength(8)` bir fonksiyon döndüren bir fonksiyondur. `notEmpty` ise parantezsiz yazılarak fonksiyonun kendisi olarak diziye eklenir.

> [!WARNING]
> Fonksiyonu bir değer olarak vermekle çağırmanın sonucunu vermek farklı şeylerdir. `notEmpty` fonksiyonun kendisidir ve tipi `(String) -> String?`'dir. `notEmpty("abc")` ise çağrının sonucudur ve tipi `String?`'dir. `[notEmpty()]` yazmak derlenmez, çünkü fonksiyon argüman olmadan çağrılamaz.

### Nested functions

Bir fonksiyon başka bir fonksiyonun içinde tanımlanabilir. İç fonksiyon dışarıdan görünmez ve dış fonksiyonun değişkenlerine erişebilir. Sadece tek bir fonksiyonda kullanılan yardımcı mantığı dışarı sızdırmadan gruplamak için kullanılır.

```swift
func formattedDuration(seconds: Int) -> String {
    func pad(_ value: Int) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }
    return "\(pad(seconds / 60)):\(pad(seconds % 60))"
}

print(formattedDuration(seconds: 125))    // 02:05
```

### Mülakat soruları

<details>
<summary><b>Argument label ile parameter name arasındaki fark ne, neden ikisi ayrı?</b></summary>

Argument label fonksiyon çağrılırken, parameter name fonksiyonun gövdesinde kullanılır. Ayrı olmaları çağrı noktasının bir cümle gibi okunmasını sağlar. Örneğin `move(from: a, to: b)` çağrıda doğal okunur, gövdede ise `source` ve `destination` gibi daha açık isimler kullanılabilir. İlk argüman fonksiyon adıyla zaten anlaşılıyorsa label `_` ile kaldırılır.
</details>

<details>
<summary><b>inout nasıl çalışır? Referans ile geçirmek mi?</b></summary>

Hayır, copy in copy out şeklinde çalışır. Değer fonksiyona kopyalanır, fonksiyon bittiğinde değiştirilmiş hali orijinal değişkene yazılır. Bu yüzden sadece `var` verilebilir ve çağrıda `&` yazmak zorunludur. Derleyici bazı durumlarda bunu referans ile geçirme şeklinde optimize edebilir ama anlam olarak copy in copy out'tur. Aynı değişkene aynı anda iki `inout` erişim derleyici tarafından engellenir (bkz. [Memory Safety](#27-memory-safety)).
</details>

<details>
<summary><b>Default parameter value mu, overload mu?</b></summary>

Aynı işi yapan ama bazı parametreleri isteğe bağlı olan fonksiyonlar için varsayılan değer tercih edilir. Tek bir implementasyon olur ve tüm kombinasyonlar desteklenir. Overload, parametre tipleri ya da davranış gerçekten farklıysa anlamlıdır.
</details>

<details>
<summary><b>Swift'te fonksiyonların first class olması ne demek?</b></summary>

Fonksiyonlar diğer değerler gibi davranır. Bir değişkene atanabilir, bir koleksiyonda saklanabilir, başka bir fonksiyona parametre olarak verilebilir ve bir fonksiyondan döndürülebilir. `map`, `filter`, `sorted(by:)` gibi API'ler ve completion handler'lar bu özelliğe dayanır.
</details>

<details>
<summary><b>@discardableResult ne işe yarar?</b></summary>

Değer döndüren bir fonksiyonun sonucu kullanılmadığında derleyici uyarı verir. Sonucu çoğu zaman kullanılmayan fonksiyonlar `@discardableResult` ile işaretlenerek bu uyarı kaldırılır. Örnekler: silinen değeri de döndüren bir `remove` fonksiyonu ya da zincirleme kullanım için `self` döndüren bir builder metodu.
</details>

---

## 7. Closures

Closure, bir değişkene atanabilen ya da parametre olarak verilebilen bir kod bloğudur. Fonksiyonlar aslında closure'ın özel bir halidir. Closure'ları güçlü yapan özellik, tanımlandıkları yerdeki değişkenleri yakalayıp (capture) daha sonra çalıştırıldıklarında da kullanabilmeleridir.

Swift'te closure'ın üç biçimi vardır:

- Global fonksiyonlar: isimleri vardır, hiçbir değer yakalamazlar.
- Nested fonksiyonlar: isimleri vardır, dış fonksiyonun değerlerini yakalayabilirler.
- Closure expression'lar: isimsizdir, çevrelerindeki değerleri yakalayabilirler.

### Closure expression söz dizimi

Closure'ın tam yazımı süslü parantez içinde parametreler, dönüş tipi ve `in` anahtar kelimesinden sonra gövdeden oluşur. Swift, bağlamdan çıkarabildiği her şeyi yazmamaya izin verir.

```swift
let usernames = ["zeynep", "ali", "berk"]

let a = usernames.sorted(by: { (lhs: String, rhs: String) -> Bool in
    return lhs < rhs
})
let b = usernames.sorted(by: { lhs, rhs in lhs < rhs })    // tipler ve return çıkarıldı
let c = usernames.sorted { $0 < $1 }                       // shorthand argument names, trailing closure
let d = usernames.sorted(by: <)                            // operatörün kendisi bir fonksiyondur

print(d)    // ["ali", "berk", "zeynep"]
```

`$0`, `$1` kısa yazımları closure tek satır ve anlamı açık olduğunda kullanılır. Gövde uzadığında parametrelere isim vermek okunabilirliği korur.

### Trailing closures

Bir fonksiyonun son parametresi closure ise, closure parantezlerin dışına yazılabilir. Closure tek parametre ise parantezler tamamen kaldırılabilir. Birden fazla closure parametresi varsa ilki label'sız, sonrakiler label ile yazılır. SwiftUI'daki `Button { } label: { }` kullanımı bu şekildedir.

```swift
func performRequest(
    _ path: String,
    onSuccess: (String) -> Void,
    onFailure: (Int) -> Void
) {
    path.hasPrefix("/v1") ? onSuccess("{}") : onFailure(404)
}

performRequest("/v1/me") { body in
    print("Body: \(body)")
} onFailure: { code in
    print("Failed with \(code)")
}
```

### Closure'ı çağırmak

Closure bir değerdir. Tanımlamak onu çalıştırmaz. Çalıştırmak için sonuna parantez eklenir, tıpkı bir fonksiyon gibi.

```swift
let refresh: () -> Void = {
    print("Refreshing feed")
}

let action = refresh    // closure'ın kendisi, hiçbir şey yazdırılmaz
action()                // Refreshing feed
```

> [!WARNING]
> `{ }` closure'ı paketler, `()` çalıştırır. Bir property'de saklanan `transform` closure'ını çalıştırmak için `transform(value)` yazılır. Sadece `transform` yazmak closure'ı bir değer olarak verir. Optional bir closure `onChange?(value)` şeklinde çağrılır.

### Capturing values

Closure, gövdesinde kullandığı dış değişkenleri yakalar. Yakalama, değişkenin o anki değerini kopyalamak değil, değişkenin kendisine bir referans tutmaktır. Değişken sonradan değişirse closure yeni değeri görür. Closure'ın yakaladığı değişken, tanımlandığı kapsam bitse bile closure yaşadığı sürece yaşar.

```swift
func makeIDGenerator(prefix: String) -> () -> String {
    var next = 0
    return {
        next += 1
        return "\(prefix)-\(next)"
    }
}

let nextOrderID = makeIDGenerator(prefix: "ORD")
print(nextOrderID())    // ORD-1
print(nextOrderID())    // ORD-2

let nextInvoiceID = makeIDGenerator(prefix: "INV")
print(nextInvoiceID())  // INV-1
```

`makeIDGenerator` fonksiyonu bittiğinde `next` değişkeni yok olmaz, çünkü döndürülen closure onu yakalamıştır. Her çağrı kendi `next` değişkenine sahip yeni bir closure üretir.

Değişkenin o anki değerini sabitlemek için capture list kullanılır. Capture list'teki değer, closure oluşturulduğu anda kopyalanır.

```swift
func makeLoggers() -> (live: () -> Void, snapshot: () -> Void) {
    var environment = "staging"
    let live = { print("live: \(environment)") }
    let snapshot = { [environment] in print("snapshot: \(environment)") }
    environment = "production"
    return (live, snapshot)
}

let loggers = makeLoggers()
loggers.live()        // live: production
loggers.snapshot()    // snapshot: staging
```

> [!IMPORTANT]
> Closure'lar reference type'tır. Bir closure'ı başka bir değişkene atamak yeni bir kopya oluşturmaz, iki değişken aynı closure'ı ve aynı yakalanmış değişkenleri gösterir. Bu özellik, bir class'ın kendi property'sinde sakladığı closure içinde `self`'i yakaladığında retain cycle oluşmasının sebebidir.

### Escaping closures

Bir fonksiyona verilen closure, fonksiyon döndükten sonra çağrılacaksa ya da bir yerde saklanacaksa `@escaping` olarak işaretlenmelidir. Completion handler'lar, bir property'de saklanan callback'ler ve asenkron çalışan işler bu duruma örnektir. `@escaping` bir attribute'tur ve parametrenin tipine yazılır.

Closure parametreleri varsayılan olarak non-escaping'dir. Derleyici, non-escaping bir closure'ın fonksiyon bitmeden çalışıp yok olacağını bilir. Bu sayede daha iyi optimizasyon yapar ve closure içinde `self` yazmayı zorunlu tutmaz.

```swift
struct User {
    let id: Int
    let name: String
}

enum ServiceError: Error {
    case notFound
}

final class UserService {
    private var pendingRequests: [(Result<User, ServiceError>) -> Void] = []

    func fetchUser(id: Int, completion: @escaping (Result<User, ServiceError>) -> Void) {
        pendingRequests.append(completion)    // saklandığı için @escaping zorunlu
    }

    func deliver(_ result: Result<User, ServiceError>) {
        pendingRequests.forEach { $0(result) }
        pendingRequests.removeAll()
    }
}

final class ProfileViewModel {
    private let service: UserService
    private(set) var title = "Loading"

    init(service: UserService) {
        self.service = service
    }

    func load() {
        service.fetchUser(id: 42) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user): self.title = user.name
            case .failure: self.title = "Something went wrong"
            }
        }
    }
}

let service = UserService()
let viewModel = ProfileViewModel(service: service)
viewModel.load()
service.deliver(.success(User(id: 42, name: "Ada")))
print(viewModel.title)    // Ada
```

> [!IMPORTANT]
> Escaping closure içinde `self`'in açıkça yazılması zorunludur. Swift bunu bilinçli olarak ister: `self` yazdığın anda closure'ın `self`'i güçlü şekilde tuttuğunu görürsün. Closure `self`'in bir property'sinde saklanıyorsa ya da `self`'ten uzun yaşayabiliyorsa `[weak self]` kullanılır. Ayrıntılar [Automatic Reference Counting](#26-automatic-reference-counting) bölümünde.

> [!NOTE]
> Struct ve enum gibi value type'larda escaping closure içinde `self` değiştirilemez. Closure, fonksiyon bittikten sonra çalışabileceği için o anda değiştirilecek bir `self` kopyası artık olmayabilir.

### Autoclosures

`@autoclosure`, parametre olarak verilen bir ifadeyi otomatik olarak closure'a sarar. Böylece ifade, çağrıldığı anda değil, fonksiyon gerçekten ihtiyaç duyduğunda değerlendirilir. `??`, `assert` ve `&&` operatörlerinin sağ tarafı bu şekilde çalışır.

```swift
let isVerboseLoggingEnabled = false

func debugLog(_ message: @autoclosure () -> String) {
    guard isVerboseLoggingEnabled else { return }
    print(message())
}

let payload = Array(repeating: "item", count: 10_000)
debugLog("Payload: \(payload.joined(separator: ","))")    // loglama kapalıyken string hiç oluşturulmaz
```

### Higher order functions

Koleksiyonlarla çalışırken en sık kullanılan closure tabanlı API'ler:

| Fonksiyon | Ne yapar | Dönüş |
|---|---|---|
| `map` | Her elemanı dönüştürür | Aynı uzunlukta yeni dizi |
| `compactMap` | Dönüştürür, `nil` sonuçları atar | Optional olmayan yeni dizi |
| `flatMap` | Her eleman için dizi üretir, sonuçları tek dizide birleştirir | Düzleştirilmiş dizi |
| `filter` | Koşula uyanları tutar | Yeni dizi |
| `reduce` | Tüm elemanları tek bir değerde toplar | Tek değer |
| `first(where:)` | Koşula uyan ilk eleman | Optional |
| `contains(where:)` | Koşula uyan eleman var mı | `Bool` |
| `allSatisfy` | Tüm elemanlar koşula uyuyor mu | `Bool` |
| `sorted(by:)` | Sıralanmış yeni dizi | Yeni dizi |

```swift
struct LineItem {
    let sku: String
    let quantity: Int
    let unitPrice: Decimal
}

let cart = [
    LineItem(sku: "KB-01", quantity: 1, unitPrice: 1_200),
    LineItem(sku: "MS-07", quantity: 2, unitPrice: 350),
    LineItem(sku: "CB-11", quantity: 0, unitPrice: 90)
]

let skus = cart.map(\.sku)
let purchasable = cart.filter { $0.quantity > 0 }
let total = purchasable.reduce(0) { sum, item in sum + item.unitPrice * Decimal(item.quantity) }

print(skus)     // ["KB-01", "MS-07", "CB-11"]
print(total)    // 1900

let couponInputs = ["10", "abc", "25"]
let discounts = couponInputs.compactMap { Int($0) }
print(discounts)    // [10, 25]
```

`reduce(into:)`, sonucun bir koleksiyon olduğu durumlarda her adımda yeni kopya oluşturmadığı için daha verimlidir.

```swift
let quantitiesBySKU = cart.reduce(into: [String: Int]()) { result, item in
    result[item.sku] = item.quantity
}
print(quantitiesBySKU["MS-07"] ?? 0)    // 2
```

> [!WARNING]
> `reduce` closure'ında ilk parametre (`$0`) o ana kadar biriken sonuçtur, ikinci parametre (`$1`) sıradaki elemandır. `$0`'ı eleman sanmak sık yapılan bir hatadır. `reduce` closure'larında parametrelere isim vermek (`sum, item`) bu karışıklığı önler.

> [!TIP]
> `forEach` yerine çoğu zaman `for-in` tercih edilir. `forEach` içinde `break` ve `continue` kullanılamaz, `return` ise sadece o turu bitirir. `forEach`, kısa ve yan etki üreten zincirlerin sonunda anlamlıdır.

### Mülakat soruları

<details>
<summary><b>Closure nedir, fonksiyondan farkı ne?</b></summary>

Closure, bir değer olarak taşınabilen bir kod bloğudur ve tanımlandığı ortamdaki değişkenleri yakalayabilir. Fonksiyonlar aslında isimli closure'lardır. Global fonksiyonlar hiçbir değer yakalamaz. Nested fonksiyonlar ve closure expression'lar ise çevrelerindeki değişkenleri yakalar ve bu değişkenler, tanımlandıkları kapsam bitse bile closure yaşadığı sürece yaşar.
</details>

<details>
<summary><b>@escaping ne demek, closure'lar neden varsayılan olarak non-escaping?</b></summary>

`@escaping`, closure'ın fonksiyon döndükten sonra çağrılabileceğini ya da bir yerde saklanabileceğini belirten bir attribute'tur. Completion handler'lar en tipik örnektir. Varsayılan non-escaping'dir çünkü derleyici, closure'ın fonksiyon içinde çalışıp biteceğini bildiğinde daha iyi optimizasyon yapabilir. Ayrıca non-escaping closure'larda retain cycle riski olmadığı için `self` açıkça yazılmak zorunda değildir.
</details>

<details>
<summary><b>Escaping closure içinde neden self yazmak zorundayız?</b></summary>

Escaping closure, `self`'i güçlü şekilde yakalar ve fonksiyon bittikten sonra da yaşayabilir. `self` de o closure'ı saklıyorsa retain cycle oluşur. Swift, `self`'i açıkça yazdırarak geliştiricinin bu yakalamanın farkında olmasını sağlar. Gerekirse `[weak self]` ile güçlü yakalama engellenir.
</details>

<details>
<summary><b>Closure'lar value type mı reference type mı? Bunun pratik sonucu ne?</b></summary>

Reference type'tır. Bir closure'ı başka bir değişkene atamak aynı closure'ı ve aynı yakalanmış değişkenleri paylaşmak anlamına gelir. Pratik sonucu şudur: bir class kendi property'sinde bir closure saklar ve o closure `self`'i güçlü şekilde yakalarsa ikisi birbirini tutar ve hiçbiri bellekten silinmez.
</details>

<details>
<summary><b>Capture list ne işe yarar?</b></summary>

İki işe yarar. Birincisi, bir değişkenin closure oluşturulduğu andaki değerini kopyalar. Sonradan değişken değişse bile closure eski değeri kullanır. İkincisi, reference type'ların nasıl yakalanacağını belirler. `[weak self]` ve `[unowned self]` retain cycle'ı kırmak için kullanılır.
</details>

<details>
<summary><b>map, compactMap ve flatMap arasındaki fark ne?</b></summary>

`map` her elemanı dönüştürür ve aynı uzunlukta bir dizi döndürür. `compactMap` dönüştürme sonucu optional olduğunda `nil` olanları atar ve sadece dolu değerleri döndürür, örneğin `["1", "x"].compactMap { Int($0) }` sonucu `[1]` olur. `flatMap` her eleman için bir dizi üretir ve bunları tek bir diziye birleştirir.
</details>

<details>
<summary><b>@autoclosure nedir, nerede kullanılır?</b></summary>

Parametre olarak verilen ifadeyi otomatik olarak bir closure'a sarar. Böylece ifade, fonksiyon gerçekten ihtiyaç duyduğunda değerlendirilir. `??` operatörünün sağ tarafı, `assert`'in mesajı ve `&&`'nin sağ tarafı bu şekilde çalışır. Kendi kodumda pahalı log mesajlarını sadece loglama açıkken oluşturmak için kullanabilirim.
</details>

---

## 8. Enumerations

Enum, birbiriyle ilişkili bir grup değeri tek bir tip altında toplar. Swift'te enum'lar C'dekinden çok daha güçlüdür: her case'e farklı tipte veri (associated value) iliştirilebilir, metot ve computed property tanımlanabilir, protokollere uyulabilir. Bir değerin sadece belirli durumlardan biri olabildiği her yerde ilk akla gelen araçtır.

### Temel kullanım ve CaseIterable

```swift
enum Environment: CaseIterable {
    case development, staging, production

    var baseURL: String {
        switch self {
        case .development: "http://localhost:8080"
        case .staging: "https://staging.api.example.com"
        case .production: "https://api.example.com"
        }
    }
}

let current = Environment.staging
print(current.baseURL)
print(Environment.allCases.count)    // 3
```

`CaseIterable`, tüm case'leri içeren `allCases` dizisini otomatik üretir. Ayarlar ekranında seçenek listesi göstermek gibi durumlarda kullanılır.

### Raw values

Her case'e aynı tipte sabit bir değer verilebilir. Raw value tipi `String`, `Character`, tam sayı ya da ondalıklı sayı olabilir. `String` raw value'da değer verilmezse case'in adı, `Int`'te ise sıfırdan başlayarak artan sayılar kullanılır.

Raw value'dan enum oluşturan `init?(rawValue:)` failable'dır, çünkü verilen değere karşılık gelen bir case olmayabilir.

```swift
enum OrderStatus: String, Codable {
    case pending
    case shipped
    case delivered
    case cancelled = "canceled"
}

let fromAPI = OrderStatus(rawValue: "shipped")    // .shipped
let unknown = OrderStatus(rawValue: "returned")   // nil

let json = #"{"status": "canceled"}"#.data(using: .utf8)!
struct OrderDTO: Codable {
    let status: OrderStatus
}
let order = try JSONDecoder().decode(OrderDTO.self, from: json)
print(order.status)    // cancelled
```

> [!TIP]
> API'den gelen string değerleri doğrudan `String` olarak saklamak yerine raw value'lu bir enum'a çevirmek yazım hatalarını ortadan kaldırır ve `switch` ile tüm durumların ele alınmasını sağlar. Case adı Swift isimlendirme kurallarına uyarken (`cancelled`), raw value API'nin beklediği değeri (`canceled`) taşıyabilir.

> [!WARNING]
> Sunucu, enum'da olmayan yeni bir değer göndermeye başlarsa decode işlemi hata fırlatır ve tüm cevap çözümlenemez. Kritik durumlarda bilinmeyen değerleri karşılayan bir case eklemek ya da decode'u özelleştirmek gerekir.

### Associated values

Associated value, bir case'e o case'e özel veri iliştirir. Her case farklı tipte ve sayıda değer taşıyabilir. Bu özellik bir ekranın durumunu modellemek için idealdir.

```swift
struct Article {
    let title: String
}

enum LoadState {
    case idle
    case loading
    case loaded([Article])
    case failed(message: String, canRetry: Bool)
}

func render(_ state: LoadState) -> String {
    switch state {
    case .idle:
        "Pull to refresh"
    case .loading:
        "Loading"
    case .loaded(let articles) where articles.isEmpty:
        "No articles yet"
    case .loaded(let articles):
        "\(articles.count) articles"
    case .failed(let message, canRetry: true):
        "\(message). Tap to retry"
    case .failed(let message, canRetry: false):
        message
    }
}

print(render(.loaded([Article(title: "Swift 6"), Article(title: "SwiftData")])))   // 2 articles
print(render(.failed(message: "Offline", canRetry: true)))             // Offline. Tap to retry
```

> [!IMPORTANT]
> Bu yaklaşım, geçersiz durumların temsil edilememesini sağlar. Aynı ekran `isLoading: Bool`, `articles: [Article]`, `error: String?` property'leriyle modellenseydi "hem yükleniyor hem hata var" gibi anlamsız kombinasyonlar mümkün olurdu. Enum ile ekran aynı anda sadece tek bir durumda olabilir.

Sadece tek bir case'i kontrol etmek için `switch` yerine `if case` ya da `guard case` kullanılır.

```swift
let state = LoadState.failed(message: "Timeout", canRetry: true)

if case .failed(let message, _) = state {
    print("Log: \(message)")
}
```

> [!NOTE]
> Bir enum'da raw value ve associated value birlikte kullanılamaz. Raw value derleme anında sabittir. Associated value ise her instance oluşturulduğunda verilir.

### Metotlar ve mutating

Enum'lar metot ve computed property içerebilir. Enum'un kendi değerini değiştiren metotlar `mutating` olarak işaretlenir.

```swift
enum PlaybackState {
    case playing, paused, stopped

    mutating func togglePlayPause() {
        switch self {
        case .playing: self = .paused
        case .paused, .stopped: self = .playing
        }
    }
}

var playback = PlaybackState.stopped
playback.togglePlayPause()
print(playback)    // playing
```

### Recursive enumerations

Bir case'in associated value'su enum'un kendi tipini içeriyorsa case `indirect` olarak işaretlenir. Swift bu durumda değeri dolaylı olarak, ayrı bir bellek alanında saklar. İç içe filtreler ya da ifade ağaçları gibi yapılar için kullanılır.

```swift
struct Product {
    let price: Int
    let tags: Set<String>
}

indirect enum Filter {
    case tag(String)
    case maxPrice(Int)
    case and(Filter, Filter)
    case or(Filter, Filter)

    func matches(_ product: Product) -> Bool {
        switch self {
        case .tag(let tag): product.tags.contains(tag)
        case .maxPrice(let limit): product.price <= limit
        case .and(let lhs, let rhs): lhs.matches(product) && rhs.matches(product)
        case .or(let lhs, let rhs): lhs.matches(product) || rhs.matches(product)
        }
    }
}

let filter = Filter.and(.tag("wireless"), .or(.maxPrice(500), .tag("sale")))
let headphones = Product(price: 900, tags: ["wireless", "sale"])
print(filter.matches(headphones))    // true
```

### Case'siz enum ile namespace

Hiç case'i olmayan bir enum'dan instance oluşturulamaz. Bu özellik, sabitleri ve static yardımcıları bir isim altında toplamak için kullanılır. Aynı iş için struct kullanılsaydı `APIConstants()` şeklinde anlamsız bir instance oluşturmak mümkün olurdu.

```swift
enum APIConstants {
    static let baseURL = URL(string: "https://api.example.com")!
    static let timeout: TimeInterval = 30
    static let maxRetryCount = 3
}
```

### Framework enum'ları ve @unknown default

Apple framework'lerindeki bazı enum'lar ileride yeni case'ler alabilir (non-frozen). Bunlar üzerinde `switch` yazarken bilinen case'lerin hepsi yazılır ve sona `@unknown default` eklenir. Yeni bir SDK ile derlendiğinde eklenen case için derleyici uyarı verir, eski bir SDK'daki uygulama ise yeni case geldiğinde crash olmadan varsayılan dala düşer. `UNAuthorizationStatus` ve `AVAuthorizationStatus` gibi izin durumları tipik örneklerdir.

### Mülakat soruları

<details>
<summary><b>Raw value ile associated value arasındaki fark ne?</b></summary>

Raw value her case'e derleme anında verilen sabit bir değerdir ve tüm case'lerde aynı tiptedir. API'den gelen string'leri enum'a çevirmek için kullanılır. Associated value ise instance oluşturulurken verilen ve case'e göre tipi değişebilen veridir. Bir ekranın `loaded([Item])` ya da `failed(Error)` gibi durumlarını modellemek için kullanılır. İkisi aynı enum'da birlikte kullanılamaz.
</details>

<details>
<summary><b>Bir ekranın durumunu neden ayrı Bool ve optional property'ler yerine enum ile modellersin?</b></summary>

Ayrı property'lerle "hem yükleniyor hem hata var" ya da "hata var ama veri de dolu" gibi geçersiz kombinasyonlar oluşabilir ve her yerde bunları kontrol etmek gerekir. Associated value'lu bir enum ile ekran aynı anda sadece tek bir durumda bulunabilir ve her durum kendi verisini taşır. `switch` ile tüm durumların ele alınması da derleyici tarafından garanti edilir.
</details>

<details>
<summary><b>@unknown default ne zaman kullanılır?</b></summary>

Apple framework'leri gibi ileride yeni case eklenebilecek enum'lar üzerinde `switch` yazarken kullanılır. Bilinen tüm case'ler yazılır, sona `@unknown default` eklenir. Yeni bir case eklendiğinde derleyici uyarı verir, ama uygulama çalışma anında crash olmadan varsayılan dala düşer.
</details>

<details>
<summary><b>indirect ne işe yarar?</b></summary>

Kendi tipini associated value olarak içeren recursive enum'larda kullanılır. Normalde enum'un boyutu derleme anında bilinmelidir. Kendini içeren bir case'in boyutu ise sonsuz olurdu. `indirect`, değeri ayrı bir bellek alanında saklayıp enum'da sadece ona referans tutarak bu sorunu çözer.
</details>

<details>
<summary><b>Sabitleri gruplamak için neden struct değil de case'siz enum kullanılır?</b></summary>

Case'i olmayan bir enum'dan instance oluşturulamaz, bu yüzden sadece bir namespace olarak kullanılabilir. Struct kullanılsaydı anlamsız bir instance oluşturmak mümkün olurdu. Bunu engellemek için `private init()` yazmak gerekirdi.
</details>

---

## 9. Structures and Classes

Struct ve class, property ve metotlarla kendi tiplerini tanımlamanın iki yoludur. İkisi de property, metot, subscript ve initializer tanımlayabilir, extension ile genişletilebilir ve protokollere uyabilir. Aralarındaki temel fark, struct'ın value type, class'ın reference type olmasıdır.

### Sadece class'ta olanlar

- Inheritance: bir class başka bir class'tan türeyebilir.
- Type casting: bir instance'ın gerçek tipi çalışma anında kontrol edilebilir.
- Deinitializer: instance bellekten silinmeden önce `deinit` çalışır.
- Reference counting: bir instance'a birden fazla referans olabilir ve ARC bunları sayar.
- Identity: iki referansın aynı nesneyi gösterip göstermediği `===` ile kontrol edilebilir.

### Value semantics ve reference semantics

Struct bir değişkene atandığında ya da fonksiyona verildiğinde kopyalanır. Kopyadaki değişiklik orijinali etkilemez. Class ise kopyalanmaz. Atanan şey aynı nesneye bir referanstır ve değişiklik o nesneyi gösteren herkese yansır.

```swift
struct DraftSettings {
    var fontSize: Int
}

final class SharedSettings {
    var fontSize: Int
    init(fontSize: Int) { self.fontSize = fontSize }
}

var draftA = DraftSettings(fontSize: 14)
var draftB = draftA
draftB.fontSize = 18
print(draftA.fontSize, draftB.fontSize)    // 14 18

let sharedA = SharedSettings(fontSize: 14)
let sharedB = sharedA
sharedB.fontSize = 18
print(sharedA.fontSize, sharedB.fontSize)  // 18 18
print(sharedA === sharedB)                 // true
```

Bu fark, uygulamadaki birçok hatanın kaynağıdır. Bir ekranda düzenlenen nesne class ise, kullanıcı "İptal" dediğinde bile değişiklik listedeki orijinal nesneye yansımış olur. Struct ile düzenleme ekranı kendi kopyası üzerinde çalışır ve sadece "Kaydet" dendiğinde değer geri yazılır.

> [!IMPORTANT]
> `let` struct'ta ve class'ta farklı davranır. `let` ile tanımlanan bir struct'ın hiçbir property'si değiştirilemez, çünkü struct değerin kendisidir. `let` ile tanımlanan bir class instance'ında ise sadece referans sabittir. `var` property'ler değiştirilebilir. Yukarıdaki `sharedB` bu yüzden `let` olmasına rağmen güncellenebiliyor.

### Memberwise initializer

Struct'lar, tüm stored property'leri parametre olarak alan bir initializer'ı otomatik olarak alır. Varsayılan değeri olan property'ler bu initializer'da isteğe bağlı parametre olur. Class'larda böyle bir initializer yoktur, `init` elle yazılır.

```swift
struct APIRequest {
    let path: String
    var method = "GET"
    var headers: [String: String] = [:]
}

let profile = APIRequest(path: "/me")
let update = APIRequest(path: "/me", method: "PATCH", headers: ["Content-Type": "application/json"])
```

> [!NOTE]
> Struct'a kendi `init`'ini yazdığında memberwise initializer kaybolur. İkisini birlikte kullanmak istiyorsan özel `init`'i bir extension içine yazarsın (bkz. [Initialization](#14-initialization)).

### Struct mı class mı

Apple'ın önerisi varsayılan olarak struct kullanmaktır. Class'a ancak gerçekten class'a özel bir özellik gerektiğinde geçilir.

| Durum | Tercih | Gerekçe |
|---|---|---|
| Veri modeli (`User`, `Order`, API DTO'su) | struct | Bağımsız kopyalar, beklenmedik paylaşım yok, otomatik `Equatable`/`Codable`/memberwise init |
| Kimliği önemli, paylaşılan ve değişen durum (oturum yöneticisi, cache) | class | Herkes aynı nesneyi görmeli |
| Yaşam döngüsü önemli (`deinit` ile kaynak bırakma) | class | Struct'ta `deinit` yoktur |
| UIKit'ten türeme (`UIViewController`) ya da Objective-C uyumluluğu | class | Inheritance ve `NSObject` gerekir |
| SwiftUI'da gözlemlenen model (`@Observable`) | class | Macro sadece class'lara uygulanır |
| SwiftUI view'ları | struct | Hafif, sık oluşturulup atılan değerler |

> [!TIP]
> Bir class'tan türetme yapılmayacaksa `final` olarak işaretlenir. `final`, niyeti açıkça belirtir ve derleyicinin metot çağrılarını dinamik dispatch yerine doğrudan çağrıya çevirmesine (static dispatch) izin verir.

### Değişikliğin yayılması

Bir struct, başka bir struct'ın ya da dizinin içindeyse ve bir property'si değiştirilirse, değişiklik dıştaki değere de yansır. Çünkü değiştirilen şey zaten dıştaki değerin bir parçasıdır.

```swift
struct CartItem {
    let sku: String
    var quantity: Int
}

var items = [CartItem(sku: "KB-01", quantity: 1)]
items[0].quantity += 1         // dizideki eleman yerinde güncellenir
print(items[0].quantity)       // 2

var copy = items[0]
copy.quantity = 10             // sadece kopya değişir
print(items[0].quantity)       // 2
```

> [!WARNING]
> `for item in items { item.quantity += 1 }` derlenmez, çünkü döngü değişkeni her elemanın sabit bir kopyasıdır. Dizideki struct'ları güncellemek için index üzerinden gidilir (`for index in items.indices { items[index].quantity += 1 }`) ya da `map` ile yeni dizi oluşturulur.

### Mülakat soruları

<details>
<summary><b>Struct ve class arasındaki farklar neler?</b></summary>

Struct value type'tır, atandığında ya da fonksiyona verildiğinde kopyalanır. Class reference type'tır ve atandığında aynı nesneye yeni bir referans oluşturulur. Sadece class'larda olan özellikler: inheritance, type casting, `deinit`, ARC ile reference counting ve `===` ile identity kontrolü. Struct'lar otomatik memberwise initializer alır. `let` ile tanımlanan struct tamamen değişmezdir, class'ta ise sadece referans sabittir. Struct'ta değişiklik yapan metotlar `mutating` olarak işaretlenir.
</details>

<details>
<summary><b>Bir model için struct mı class mı seçersin, neden?</b></summary>

Varsayılan olarak struct seçerim. Value semantics sayesinde bir değeri değiştirdiğimde başka bir yerin beklenmedik şekilde etkilenmeyeceğini bilirim. Bu, özellikle birden fazla thread'in aynı veriyle çalıştığı durumlarda büyük avantajdır. Class'ı şu durumlarda seçerim: nesnenin kimliği önemliyse ve birden fazla yer aynı değişen durumu görmeliyse (oturum yöneticisi gibi), `deinit` ile yaşam döngüsünü yönetmem gerekiyorsa, UIKit'ten türetme ya da Objective-C uyumluluğu gerekiyorsa ya da SwiftUI'da `@Observable` kullanacaksam.
</details>

<details>
<summary><b>Struct her zaman stack'te, class her zaman heap'te mi tutulur?</b></summary>

Bu yaygın bir basitleştirmedir ama tam doğru değildir. Class instance'ları heap'te tutulur. Struct'lar ise genellikle stack'te tutulur ama bir closure tarafından yakalandığında, `any` ile bir existential kutusuna konduğunda ya da `Array` gibi heap'te depolama kullanan bir tipin içinde olduğunda heap'e taşınabilir. Asıl fark bellekte nerede durduklarından çok semantiktedir: value semantics ile reference semantics.
</details>

<details>
<summary><b>== ile === arasındaki fark ne?</b></summary>

`==` iki değerin eşit olup olmadığını kontrol eder ve tipin `Equatable`'a uymasını gerektirir. Eşitliğin ne anlama geldiğini tip kendisi tanımlar. `===` sadece class instance'larında çalışır ve iki referansın bellekteki aynı nesneyi gösterip göstermediğini kontrol eder.
</details>

<details>
<summary><b>final anahtar kelimesi ne işe yarar?</b></summary>

Bir class'ın alt sınıfının oluşturulmasını ya da bir metodun override edilmesini engeller. Niyeti açıkça belirtir. Ayrıca derleyici, override edilemeyeceğini bildiği metotları dinamik dispatch yerine doğrudan çağırabilir, bu da küçük bir performans kazancı sağlar.
</details>

<details>
<summary><b>SwiftUI view'ları neden struct?</b></summary>

SwiftUI'da view'lar, ekranın o anki durumunun hafif bir tarifidir. Durum her değiştiğinde yeniden oluşturulurlar. Struct'lar ucuzdur, inheritance yükü taşımaz ve value semantics sayesinde SwiftUI eski ve yeni tarifi karşılaştırıp sadece değişen kısmı güncelleyebilir. Değişen durum ise view'da değil, `@State` ya da `@Observable` bir model gibi SwiftUI'ın yönettiği depolama alanında tutulur.
</details>

---

## 10. Properties

Property, bir değeri bir tipe bağlar. Stored property değeri instance'ın içinde saklar. Computed property ise değeri saklamaz, her erişildiğinde hesaplar. Bu ikisinin üzerine property observer'lar, lazy property'ler, property wrapper'lar ve type property'ler gelir.

### Stored properties

Stored property'ler `let` ya da `var` ile tanımlanır. Struct'larda, instance `let` ile tanımlandıysa `var` property'ler bile değiştirilemez.

```swift
struct Coordinate {
    var latitude: Double
    var longitude: Double
}

let office = Coordinate(latitude: 41.04, longitude: 29.0)
// office.latitude = 40.0    error: cannot assign to property: 'office' is a 'let' constant
```

### Lazy stored properties

`lazy` property'nin değeri ilk erişildiğinde hesaplanır. Oluşturulması pahalı olan ya da her instance'ta gerekmeyen değerler için kullanılır. `lazy` sadece `var` olabilir, çünkü değeri init tamamlandıktan sonra atanır.

```swift
final class ReportExporter {
    lazy var formatter: DateFormatter = {
        print("Creating formatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func filename(for date: Date) -> String {
        "report-\(formatter.string(from: date)).csv"
    }
}

let exporter = ReportExporter()
print("Exporter ready")
print(exporter.filename(for: Date(timeIntervalSince1970: 0)))
// Exporter ready
// Creating formatter
// report-1970-01-01.csv
```

Sondaki `()` önemlidir. Closure'ın kendisi değil, closure'ın çalıştırılmasıyla üretilen değer property'ye atanır. Lazy property'nin closure'ı içinde `self`'e erişilebilir, çünkü ilk erişim anında instance zaten tamamen oluşturulmuş olur.

> [!WARNING]
> `lazy` property thread safe değildir. Birden fazla thread ilk erişimi aynı anda yaparsa değer birden fazla kez oluşturulabilir.

### Computed properties

Computed property bir değer saklamaz. Başka property'lerden türetilen değeri her erişimde hesaplar. Sadece getter'ı olan computed property read-only'dir ve `get` anahtar kelimesi yazılmadan tanımlanabilir.

```swift
struct Subscription {
    var monthlyPrice: Decimal
    var discountRate: Decimal

    var yearlyPrice: Decimal {
        monthlyPrice * 12 * (1 - discountRate)
    }
}

let plan = Subscription(monthlyPrice: 100, discountRate: 0.2)
print(plan.yearlyPrice)    // 960
```

Setter'ı olan computed property, kendisine atanan değeri başka bir stored property'ye çevirerek yazar. Setter içinde atanan değer `newValue` adıyla gelir.

```swift
struct TimeoutSetting {
    var milliseconds: Int

    var seconds: Double {
        get { Double(milliseconds) / 1000 }
        set { milliseconds = Int(newValue * 1000) }
    }
}

var timeout = TimeoutSetting(milliseconds: 1500)
timeout.seconds = 2.5
print(timeout.milliseconds)    // 2500
```

> [!IMPORTANT]
> Birbirinden türetilebilen iki değer varsa sadece biri stored olur, diğeri computed yapılır. Bunun asıl sebebi bellek değil, single source of truth'tur. İkisi de stored olsaydı biri güncellenip diğeri unutulduğunda `milliseconds = 1500` iken `seconds = 2.0` gibi tutarsız bir durum oluşabilirdi. Tek bir kaynak olduğunda bu tutarsızlık imkânsız hale gelir.

> [!WARNING]
> Computed property bir property'dir, metot değildir. `var summary() -> String` şeklinde bir tanım geçersizdir. Doğru yazım `var summary: String { ... }` şeklindedir ve kullanılırken parantez yazılmaz: `plan.summary`. Hesaplama pahalıysa, parametre alıyorsa ya da yan etkisi varsa computed property yerine metot tercih edilir.

### Property observers

`willSet` ve `didSet`, bir stored property'ye değer atandığında çalışır. `willSet` atama öncesinde çalışır ve yeni değere `newValue` ile erişir. `didSet` atama sonrasında çalışır ve eski değere `oldValue` ile erişir. Değer aynı olsa bile atama yapıldığı için observer'lar çalışır.

```swift
final class UploadProgress {
    var onMilestone: ((Int) -> Void)?

    var percent: Int = 0 {
        didSet {
            percent = min(max(percent, 0), 100)
            let previousMilestone = oldValue / 25
            let currentMilestone = percent / 25
            if currentMilestone > previousMilestone {
                onMilestone?(currentMilestone * 25)
            }
        }
    }
}

let progress = UploadProgress()
progress.onMilestone = { print("Reached \($0)%") }
progress.percent = 30     // Reached 25%
progress.percent = 60     // Reached 50%
progress.percent = 140    // Reached 100%
print(progress.percent)   // 100
```

`didSet` içinde property'nin kendisine tekrar değer atamak observer'ı yeniden tetiklemez. Bu yüzden yukarıdaki sınırlama işlemi sonsuz döngüye girmez.

> [!WARNING]
> `didSet` içinde yeni değer `newValue` ile değil, property'nin kendi adıyla okunur. `newValue` sadece `willSet` içinde vardır, `oldValue` ise sadece `didSet` içinde. Bir eşiğin geçildiğini anlamak için `oldValue` ile yeni değer birlikte karşılaştırılır.

> [!NOTE]
> Observer'lar initializer içindeki ilk atamada çalışmaz. Sadece instance oluşturulduktan sonraki atamalarda tetiklenir.

### Property wrappers

Property wrapper, bir property'nin nasıl saklanacağını ya da hangi kurallara uyacağını tanımlayan mantığı tekrar kullanılabilir hale getirir. Tip `@propertyWrapper` ile işaretlenir ve `wrappedValue` adında bir property içermek zorundadır. Başlangıç değeri verilebilmesi için `init(wrappedValue:)` yazılır.

```swift
@propertyWrapper
struct Clamped {
    private var value: Int
    private let range: ClosedRange<Int>

    init(wrappedValue: Int, _ range: ClosedRange<Int>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }

    var wrappedValue: Int {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

struct VideoSettings {
    @Clamped(0...100) var volume = 50
    @Clamped(1...4) var playbackSpeed = 1
}

var settings = VideoSettings()
settings.volume = 150
print(settings.volume)    // 100
```

Bir wrapper `projectedValue` tanımlarsa, bu değere property adının başına `$` eklenerek erişilir. SwiftUI'da `@State var isOn` için `$isOn` yazıldığında elde edilen `Binding` bir projected value'dur.

> [!NOTE]
> SwiftUI'daki `@State`, `@Binding`, `@Environment`, `@AppStorage` ve `@Query` property wrapper'dır. `@AppStorage("theme") var theme = "system"` gibi bir tanım, değeri `UserDefaults`'ta saklayan ve değiştiğinde view'ı güncelleyen bir wrapper kullanır. Kendi wrapper'ını yazmayı bilmek, bu araçların perde arkasını anlamayı sağlar.

### Type properties

`static` ile tanımlanan property'ler instance'a değil tipin kendisine aittir. Tüm instance'lar için tek bir değer vardır. Stored type property'ler lazy olarak, ilk erişimde ve thread safe şekilde başlatılır.

```swift
@MainActor
struct FeatureFlags {
    static let defaultFlags: Set<String> = ["newOnboarding"]
    static var overrides: [String: Bool] = [:]

    static func isEnabled(_ flag: String) -> Bool {
        overrides[flag] ?? defaultFlags.contains(flag)
    }
}

print(FeatureFlags.isEnabled("newOnboarding"))    // true
```

Class'larda computed type property'ler `static` yerine `class` ile tanımlanırsa alt sınıflar tarafından override edilebilir.

> [!WARNING]
> Swift 6 dil modunda değişebilen bir `static var`, her thread'den erişilebilen paylaşılmış bir durum olduğu için derleyici hata verir: `static property 'overrides' is not concurrency-safe`. Çözüm, durumu tek bir actor'a bağlamak ya da değeri `let` yapmaktır. Yukarıdaki örnekte tip `@MainActor` ile işaretlendi, böylece `overrides`'a sadece main thread'den erişilebilir (bkz. [Concurrency](#18-concurrency)).

### Mülakat soruları

<details>
<summary><b>Stored property ile computed property arasındaki fark ne, birbirinden türetilebilen iki değerde hangisini seçersin?</b></summary>

Stored property değeri instance'ın içinde saklar. Computed property ise hiçbir şey saklamaz, her erişimde değeri başka property'lerden hesaplar. Birbirinden türetilebilen iki değerde birini stored, diğerini computed yaparım. Sebebi single source of truth'tur. Tek bir stored değer olduğunda ikisinin birbiriyle tutarsız hale gelmesi imkânsız olur.
</details>

<details>
<summary><b>lazy property nedir, neden let olamaz?</b></summary>

Değeri ilk erişildiğinde hesaplanan stored property'dir. Oluşturulması pahalı ya da her zaman gerekmeyen değerler için kullanılır. `let` olamaz çünkü Swift'te `let` property'lerin initialization tamamlanmadan önce değer almış olması gerekir. Lazy property'nin değeri ise initialization'dan sonra, ilk erişimde atanır.
</details>

<details>
<summary><b>willSet ve didSet ne zaman çalışır, init içinde çalışırlar mı?</b></summary>

`willSet` değer atanmadan hemen önce çalışır ve yeni değere `newValue` ile erişir. `didSet` atamadan hemen sonra çalışır ve eski değere `oldValue` ile erişir. Initializer içindeki ilk atamalarda çalışmazlar, sadece instance oluşturulduktan sonraki atamalarda tetiklenirler.
</details>

<details>
<summary><b>Property wrapper nedir? SwiftUI'daki @State ile bağlantısı ne?</b></summary>

Property'nin nasıl saklanacağını ya da değerine hangi kuralların uygulanacağını tanımlayan mantığı tekrar kullanılabilir bir tipe taşır. Tip `@propertyWrapper` ile işaretlenir ve `wrappedValue` sağlar. `@State` da bir property wrapper'dır. Değeri view struct'ının içinde değil SwiftUI'ın yönettiği bir depolama alanında tutar, değer değiştiğinde view'ın yeniden çizilmesini tetikler. `$isOn` yazıldığında elde edilen `Binding`, wrapper'ın `projectedValue`'sudur.
</details>

<details>
<summary><b>static ile class anahtar kelimeleri type property ve metotlarda nasıl farklıdır?</b></summary>

İkisi de üyeyi instance'a değil tipe bağlar. `static` ile tanımlanan üye alt sınıflarda override edilemez. `class` ile tanımlanan üye ise override edilebilir. `class` sadece class'larda ve sadece computed property'ler ile metotlarda kullanılabilir.
</details>

---

## 11. Methods

Metot, belirli bir tipe bağlı fonksiyondur. Instance metotları bir instance üzerinde, type metotları tipin kendisi üzerinde çağrılır. Swift'te struct ve enum'lar da metot tanımlayabilir. Bu, Objective-C'den önemli bir farktır.

### Instance methods ve self

Her instance'ın, instance'ın kendisini gösteren örtük bir `self` property'si vardır. Çoğu zaman yazılması gerekmez. Parametre adı bir property ile aynı olduğunda ayırt etmek için yazılır.

```swift
struct Pagination {
    var page = 1
    var pageSize = 20

    func offset() -> Int {
        (page - 1) * pageSize
    }

    func with(pageSize: Int) -> Pagination {
        var copy = self
        copy.pageSize = pageSize
        return copy
    }
}

let pagination = Pagination(page: 3)
print(pagination.offset())                       // 40
print(pagination.with(pageSize: 50).offset())    // 100
```

### mutating

Value type'larda instance metotları varsayılan olarak property'leri değiştiremez. Değişiklik yapacak metot `mutating` olarak işaretlenir. `mutating` metot `self`'e tamamen yeni bir değer de atayabilir.

```swift
struct ShoppingCart {
    private(set) var items: [String: Int] = [:]

    mutating func add(_ sku: String, quantity: Int = 1) {
        items[sku, default: 0] += quantity
    }

    mutating func clear() {
        self = ShoppingCart()
    }
}

var cart = ShoppingCart()
cart.add("KB-01")
cart.add("KB-01", quantity: 2)
print(cart.items["KB-01"] ?? 0)    // 3
cart.clear()
print(cart.items.isEmpty)          // true
```

> [!WARNING]
> `mutating` bir metot `let` ile tanımlanmış bir struct üzerinde çağrılamaz. `let cart = ShoppingCart()` dedikten sonra `cart.add("KB-01")` yazmak derlenmez. Instance'ın değişmesi gerekiyorsa `var` ile tanımlanır.

> [!NOTE]
> Class'larda `mutating` yoktur. Class metotları property'leri her zaman değiştirebilir, çünkü değiştirilen şey referansın gösterdiği nesnedir, referansın kendisi değil.

### Type methods

`static func` ile tanımlanan metotlar tipin kendisi üzerinde çağrılır. Factory metotları, ortak yardımcılar ve önceden hazırlanmış örnekler için kullanılır. Type metodunun içinde `self`, instance'ı değil tipin kendisini gösterir.

```swift
struct Money {
    let amount: Decimal
    let currency: String

    static func zero(in currency: String) -> Money {
        Money(amount: 0, currency: currency)
    }

    static func parse(_ text: String) -> Money? {
        let parts = text.split(separator: " ")
        guard parts.count == 2, let amount = Decimal(string: String(parts[0])) else { return nil }
        return Money(amount: amount, currency: String(parts[1]))
    }
}

print(Money.parse("49.90 TRY")?.amount ?? 0)    // 49.9
print(Money.zero(in: "EUR").currency)           // EUR
```

### Mülakat soruları

<details>
<summary><b>mutating anahtar kelimesi neden var, class'larda neden yok?</b></summary>

Struct ve enum value type'tır ve instance'ın property'leri değerin kendisinin bir parçasıdır. Bir property'yi değiştirmek değerin kendisini değiştirmek demektir. Swift bunun açıkça belirtilmesini ister ve `let` ile tanımlanmış bir instance üzerinde `mutating` metot çağrılmasını engeller. Class'ta değiştirilen şey referansın gösterdiği nesnedir, referansın kendisi değişmez. Bu yüzden `mutating`'e gerek yoktur.
</details>

<details>
<summary><b>Bir mutating metot içinde self'e yeni değer atamak mümkün mü?</b></summary>

Evet. `mutating` metot içinde `self = ShoppingCart()` gibi bir atama yapılabilir ve instance tamamen yeni bir değerle değiştirilir. Enum'larda bu yöntem durum geçişlerini yazmak için sık kullanılır, örneğin `self = .paused`.
</details>

---

## 12. Subscripts

Subscript, bir tipin elemanlarına köşeli parantez ile erişilmesini sağlar. `array[0]` ve `dictionary["key"]` subscript kullanır. Kendi tiplerinde de subscript tanımlanabilir. Bir subscript birden fazla parametre alabilir, read-only olabilir ve farklı parametre tipleriyle overload edilebilir.

```swift
struct HTTPHeaders {
    private var storage: [String: String] = [:]

    subscript(name: String) -> String? {
        get { storage[name.lowercased()] }
        set { storage[name.lowercased()] = newValue }
    }
}

var headers = HTTPHeaders()
headers["Content-Type"] = "application/json"
print(headers["content-type"] ?? "missing")    // application/json
```

Bu örnekte subscript, başlık isimlerini büyük küçük harfe duyarsız hale getiriyor. Dışarıdan bakıldığında sıradan bir sözlük gibi kullanılıyor ama kuralı tip kendisi uyguluyor.

> [!WARNING]
> Subscript parametreleri, fonksiyonlardan farklı olarak varsayılan olarak argument label almaz. Yukarıdaki subscript `headers[name: "..."]` şeklinde değil `headers["..."]` şeklinde çağrılır. Label istenirse parametreye açıkça iki isim verilir: `subscript(row row: Int) -> ...`.

Birden fazla parametreli subscript, iki boyutlu yapılar için kullanılır.

```swift
struct SeatMap {
    let rows: Int
    let columns: Int
    private var reserved: [Bool]

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        reserved = Array(repeating: false, count: rows * columns)
    }

    subscript(row: Int, column: Int) -> Bool {
        get {
            precondition(row < rows && column < columns, "Seat out of range")
            return reserved[row * columns + column]
        }
        set {
            precondition(row < rows && column < columns, "Seat out of range")
            reserved[row * columns + column] = newValue
        }
    }
}

var hall = SeatMap(rows: 10, columns: 12)
hall[2, 5] = true
print(hall[2, 5])    // true
```

Dizilerde index dışına çıkmak crash'e yol açar. Güvenli erişim için yaygın bir yöntem, label'lı bir subscript'i extension ile eklemektir.

```swift
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

let tabs = ["Home", "Search", "Profile"]
print(tabs[safe: 1] ?? "none")    // Search
print(tabs[safe: 7] ?? "none")    // none
```

`static subscript` ile tipin kendisi üzerinde çalışan subscript'ler de tanımlanabilir.

### Mülakat soruları

<details>
<summary><b>Subscript nedir, kendi tipinde ne zaman tanımlarsın?</b></summary>

Bir tipin elemanlarına köşeli parantez ile erişmeyi sağlayan özel bir üyedir. Tip doğal olarak bir koleksiyon ya da tablo gibi davranıyorsa tanımlarım. Örneğin büyük küçük harfe duyarsız bir header kabı ya da satır ve sütunla erişilen bir koltuk haritası. Erişim kuralını (normalize etme, sınır kontrolü) tipin içine gömmüş olurum.
</details>

<details>
<summary><b>Diziye güvenli index erişimi nasıl eklersin?</b></summary>

`Collection`'a extension ile `subscript(safe index: Index) -> Element?` eklerim. Index `indices` içindeyse elemanı, değilse `nil` döndürür. Label kullanmak hem normal subscript ile çakışmayı önler hem de çağrı noktasında güvenli erişim yapıldığını açıkça gösterir.
</details>

---

## 13. Inheritance

Bir class, başka bir class'ın property, metot ve subscript'lerini miras alabilir. Miras veren class superclass, alan class subclass olarak adlandırılır. Inheritance sadece class'larda vardır. Swift'te çoklu inheritance yoktur. Bir class sadece tek bir class'tan türeyebilir ama birden fazla protokole uyabilir.

### Subclassing ve override

Subclass, miras aldığı bir üyeyi yeniden tanımlamak için `override` yazmak zorundadır. Bu zorunluluk, yanlışlıkla aynı isimde bir metot tanımlayıp üst sınıfınkini ezmeyi engeller. Üst sınıfın implementasyonuna `super` ile erişilir.

```swift
class APIClient {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func headers() -> [String: String] {
        ["Accept": "application/json"]
    }

    func describe() -> String {
        "Client for \(baseURL) with \(headers().count) headers"
    }
}

final class AuthenticatedAPIClient: APIClient {
    let token: String

    init(baseURL: String, token: String) {
        self.token = token
        super.init(baseURL: baseURL)
    }

    override func headers() -> [String: String] {
        var headers = super.headers()
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}

let client: APIClient = AuthenticatedAPIClient(baseURL: "https://api.example.com", token: "abc")
print(client.describe())    // Client for https://api.example.com with 2 headers
```

`client` değişkeninin tipi `APIClient` olmasına rağmen `describe()` içindeki `headers()` çağrısı subclass'ın implementasyonunu çalıştırır. Hangi implementasyonun çalışacağı çalışma anında, nesnenin gerçek tipine göre belirlenir (dynamic dispatch).

### Property override

Subclass, miras aldığı bir property'ye getter ve setter ekleyebilir ya da property observer ekleyebilir. Stored property'nin kendisi override edilemez, ama computed bir property ile ezilebilir ya da üzerine `didSet` eklenebilir.

```swift
class Control {
    var isEnabled = true
}

final class SubmitButton: Control {
    private(set) var renderCount = 0

    override var isEnabled: Bool {
        didSet { renderCount += 1 }
    }
}

let button = SubmitButton()
button.isEnabled = false
print(button.renderCount)    // 1
```

### final

`final` olarak işaretlenen class'tan türetilemez. `final` olarak işaretlenen metot, property ya da subscript override edilemez. Türetme için tasarlanmamış her class'ın `final` olarak işaretlenmesi iyi bir alışkanlıktır.

> [!TIP]
> Inheritance mı, protokol mü? Swift'te kod paylaşımı ve soyutlama için ilk tercih protokol ve protocol extension'dır. Struct'lar da kullanabilir, bir tip birden fazla protokole uyabilir ve sıkı bir hiyerarşi oluşmaz. Inheritance genellikle UIKit gibi class tabanlı framework'lerle çalışırken (`UIViewController`, `UIView` subclass'ları) ya da ortak durumu ve kimliği olan gerçek bir "is a" ilişkisi olduğunda kullanılır.

### Mülakat soruları

<details>
<summary><b>Swift'te override neden zorunlu bir anahtar kelime?</b></summary>

Yanlışlıkla üst sınıftaki bir metotla aynı imzada bir metot yazıp onu ezmeyi engellemek için. Ayrıca `override` yazılıp üst sınıfta eşleşen bir üye yoksa derleyici hata verir. Böylece üst sınıftaki metodun adı değiştiğinde alt sınıftaki override sessizce bağımsız bir metoda dönüşmez.
</details>

<details>
<summary><b>Swift çoklu inheritance destekler mi? Desteklemiyorsa ne kullanırsın?</b></summary>

Class'lar için desteklemez, bir class sadece bir class'tan türeyebilir. Ancak bir tip birden fazla protokole uyabilir ve protocol extension'lar varsayılan implementasyon sağlayabilir. Bu yaklaşım çoklu inheritance'ın faydalarını, karmaşık hiyerarşi ve elmas problemi gibi sorunlar olmadan sağlar.
</details>

<details>
<summary><b>Dynamic dispatch nedir?</b></summary>

Çağrılacak metodun derleme anında değil, çalışma anında nesnenin gerçek tipine bakılarak seçilmesidir. Bir `APIClient` değişkeni aslında bir `AuthenticatedAPIClient` gösteriyorsa, override edilmiş metot çalışır. Class'larda bu işlem bir metot tablosu (vtable) üzerinden yapılır. `final` ya da struct kullanıldığında derleyici hangi metodun çalışacağını önceden bildiği için doğrudan çağrı (static dispatch) yapabilir.
</details>

---

## 14. Initialization

Initialization, bir instance'ı kullanıma hazırlama sürecidir. Swift'in temel kuralı şudur: initializer bittiğinde her stored property'nin bir değeri olmalıdır. Optional property'ler otomatik olarak `nil` ile başlar. Diğer tüm property'lere ya tanımda varsayılan değer verilir ya da initializer içinde değer atanır.

### Varsayılan değerler ve özel initializer'lar

Bir property her zaman aynı başlangıç değerini alıyorsa bu değer tanımda verilir. Initializer'da sadece dışarıdan gelmesi gereken değerler atanır.

```swift
struct RetryPolicy {
    let maxAttempts: Int
    let baseDelay: TimeInterval
    var attemptsMade = 0

    init(maxAttempts: Int = 3, baseDelay: TimeInterval = 0.5) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
    }
}
```

`let` property'lere initializer içinde değer atanabilir. Initialization bittikten sonra değiştirilemezler.

### Struct'larda memberwise initializer

Struct'lar, stored property'lerin hepsini parametre olarak alan memberwise initializer'ı otomatik alır. Struct'ın içinde özel bir `init` yazıldığında bu initializer kaybolur. İkisini birlikte tutmak için özel `init` bir extension içine yazılır.

```swift
struct Location {
    let latitude: Double
    let longitude: Double
}

extension Location {
    init?(text: String) {
        let parts = text.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard parts.count == 2 else { return nil }
        self.init(latitude: parts[0], longitude: parts[1])
    }
}

let a = Location(latitude: 41.0, longitude: 29.0)    // memberwise init hâlâ kullanılabilir
let b = Location(text: "41.0, 29.0")
print(b?.latitude ?? 0)    // 41.0
```

### Initializer delegation

Bir initializer işin bir kısmını aynı tipin başka bir initializer'ına devredebilir. Value type'larda bu `self.init(...)` ile yapılır. Yukarıdaki `init?(text:)` memberwise initializer'a delegate ediyor.

### Failable initializers

Geçersiz girdiyle instance oluşturmanın anlamsız olduğu durumlarda `init?` kullanılır. Başarısız olursa `return nil` yapılır ve sonuç optional olur. Raw value'lu enum'ların `init?(rawValue:)`'su ve `Int("abc")` failable initializer örnekleridir.

```swift
struct EmailAddress {
    let value: String

    init?(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard trimmed.contains("@"), !trimmed.hasPrefix("@"), !trimmed.hasSuffix("@") else {
            return nil
        }
        value = trimmed
    }
}

print(EmailAddress("  Ada@Example.com ")?.value ?? "invalid")    // ada@example.com
print(EmailAddress("not-an-email")?.value ?? "invalid")          // invalid
```

> [!TIP]
> Failable init mi, throwing init mi? Başarısızlığın tek bir anlamı varsa ("geçersiz girdi") `init?` yeterlidir. Çağıranın başarısızlığın nedenini bilmesi gerekiyorsa (kullanıcıya hangi kuralın ihlal edildiğini göstermek gibi) `init(...) throws` kullanılır.

Bu tip, geçerli bir e-posta adresi taşıdığını tipin kendisiyle garanti eder. Uygulamanın geri kalanında `String` yerine `EmailAddress` kullanıldığında doğrulamanın tekrar tekrar yapılmasına gerek kalmaz.

### Class'larda designated ve convenience initializer'lar

Class'larda inheritance olduğu için initialization daha katıdır. İki tür initializer vardır:

- **Designated initializer**: class'ın ana initializer'ıdır. Class'ın kendi property'lerinin hepsini başlatır, sonra superclass'ın bir designated initializer'ını çağırır.
- **Convenience initializer**: `convenience` ile işaretlenir. Mutlaka aynı class'ın başka bir initializer'ını çağırır. Sık kullanılan bir yapılandırmayı kısaltmak için kullanılır.

Kural üç cümleyle özetlenir. Designated initializer superclass'ın designated initializer'ını çağırır. Convenience initializer aynı class'ın başka bir initializer'ını çağırır. Convenience initializer'ın zinciri sonunda mutlaka bir designated initializer'a ulaşır.

```swift
class NetworkSession {
    let timeout: TimeInterval
    let maxConnections: Int

    init(timeout: TimeInterval, maxConnections: Int) {
        self.timeout = timeout
        self.maxConnections = maxConnections
    }

    convenience init() {
        self.init(timeout: 30, maxConnections: 6)
    }
}

final class UploadSession: NetworkSession {
    let chunkSize: Int

    init(chunkSize: Int) {
        self.chunkSize = chunkSize                          // 1. aşama: önce kendi property'leri
        super.init(timeout: 120, maxConnections: 2)         // sonra superclass
        print("Upload session ready: \(describe())")        // 2. aşama: artık self kullanılabilir
    }

    func describe() -> String {
        "\(chunkSize) bytes per chunk, timeout \(timeout)s"
    }
}

let upload = UploadSession(chunkSize: 512_000)
// Upload session ready: 512000 bytes per chunk, timeout 120.0s
```

### Two phase initialization

Class initialization iki aşamada gerçekleşir. Birinci aşamada her class, hiyerarşide aşağıdan yukarıya doğru kendi stored property'lerine değer atar. Bu aşama bitmeden `self` üzerinde metot çağrılamaz ve property okunamaz. Tüm property'ler değer aldıktan sonra ikinci aşama başlar. Bu aşamada her class, yukarıdan aşağıya doğru instance'ı özelleştirebilir, metot çağırabilir ve `self`'i kullanabilir.

> [!IMPORTANT]
> Subclass initializer'ında kendi property'lerine `super.init` çağrısından önce değer atanır. Objective-C'de ve birçok dilde sıra terstir. Swift bu sırayı, superclass'ın initializer'ı override edilmiş bir metodu çağırdığında subclass'ın henüz başlatılmamış bir property'ye erişmesini engellemek için zorunlu tutar.

### required initializers

`required` ile işaretlenen initializer'ı tüm subclass'lar implemente etmek zorundadır. UIKit'te `UIView` ya da `UIViewController` subclass'ı kendi designated initializer'ını tanımladığında `required init?(coder:)` yazmak bu yüzden zorunludur. Storyboard kullanılmıyorsa bu metot genellikle `fatalError("init(coder:) has not been implemented")` ile doldurulur.

### Varsayılan değeri closure ile vermek

Bir property'nin başlangıç değeri birkaç adımda hazırlanıyorsa, değer bir closure'ın çalıştırılmasıyla verilebilir. Closure'ın sonundaki `()` onu hemen çalıştırır. Bu closure instance henüz hazır olmadan çalıştığı için içinde `self` kullanılamaz.

```swift
struct CheckoutScreen {
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        return formatter
    }()
}
```

### Mülakat soruları

<details>
<summary><b>Designated ve convenience initializer arasındaki fark ne?</b></summary>

Designated initializer class'ın ana initializer'ıdır. Class'ın tüm stored property'lerini başlatır ve superclass'ın designated initializer'ını çağırır. Convenience initializer ise ikincil bir kısayoldur ve mutlaka aynı class'ın başka bir initializer'ını çağırır. Zincir sonunda her zaman bir designated initializer'a ulaşır. Böylece property'lerin başlatılması tek bir yerde toplanmış olur.
</details>

<details>
<summary><b>Two phase initialization nedir, neden var?</b></summary>

Birinci aşamada her class aşağıdan yukarıya doğru kendi stored property'lerine değer atar, bu aşamada `self` kullanılamaz. Tüm property'ler değer aldıktan sonra ikinci aşamada `self` kullanılabilir hale gelir ve metot çağrılabilir. Amaç, hiçbir kodun başlatılmamış bir property'ye erişmemesini garanti etmektir. Özellikle superclass initializer'ı override edilmiş bir metot çağırdığında, subclass'ın property'leri zaten hazır olmuş olur.
</details>

<details>
<summary><b>Struct'a özel bir init yazınca memberwise init kaybolur. Hem özel init hem de memberwise init nasıl tutulur?</b></summary>

Özel initializer'ı struct'ın gövdesine değil bir extension'a yazarak. Extension'daki initializer'lar memberwise initializer'ın oluşturulmasını engellemez.
</details>

<details>
<summary><b>Failable initializer ne zaman, throwing initializer ne zaman?</b></summary>

Başarısızlığın tek bir anlamı varsa ve nedeni önemli değilse failable (`init?`) kullanırım, örneğin geçersiz bir string'den `EmailAddress` oluşturmak. Çağıranın neden başarısız olduğunu bilmesi ve buna göre farklı davranması gerekiyorsa `throws` kullanırım. Örneğin bir formda hangi alanın hangi kuralı ihlal ettiğini göstermek.
</details>

<details>
<summary><b>UIViewController subclass'ında neden required init?(coder:) yazmak zorundayız?</b></summary>

`init?(coder:)`, `NSCoding` protokolünden gelen `required` bir initializer'dır ve storyboard ya da xib'den nesne oluşturulurken kullanılır. Subclass kendi designated initializer'ını tanımladığında superclass'ın initializer'larını otomatik miras almayı bırakır. `required` olan bu initializer'ın ise her subclass'ta bulunması zorunludur. Storyboard kullanılmıyorsa `fatalError` ile implemente edilir.
</details>

---

## 15. Deinitialization

Deinitializer, bir class instance'ı bellekten silinmeden hemen önce çalışır. Sadece class'larda vardır ve `deinit` anahtar kelimesiyle, parametresiz ve parantezsiz tanımlanır. Elle çağrılamaz, ARC tarafından otomatik çağrılır. Subclass'ın `deinit`'i bittikten sonra superclass'ınki otomatik olarak çalışır.

Swift belleği otomatik yönettiği için `deinit`'e çoğu zaman gerek yoktur. Kullanıldığı durumlar, ARC'ın bilmediği kaynakların bırakılmasıdır: bir observer kaydını kaldırmak, bir timer'ı durdurmak, açık bir dosyayı ya da bağlantıyı kapatmak.

```swift
final class LiveScoreSubscription {
    let matchID: Int

    init(matchID: Int) {
        self.matchID = matchID
        print("Subscribed to match \(matchID)")
    }

    deinit {
        print("Unsubscribed from match \(matchID)")
    }
}

func showMatchScreen() {
    let subscription = LiveScoreSubscription(matchID: 7)
    print("Showing match \(subscription.matchID)")
}

showMatchScreen()
print("Back to home")
// Subscribed to match 7
// Showing match 7
// Unsubscribed from match 7
// Back to home
```

`subscription` sadece fonksiyonun içinde tutulduğu için fonksiyon bittiğinde referans sayısı sıfıra düşer ve `deinit` hemen çalışır.

> [!TIP]
> `deinit` içine bir `print` koymak, bir ekranın kapandıktan sonra gerçekten bellekten silinip silinmediğini anlamanın en hızlı yoludur. Ekran kapandığı halde mesaj görünmüyorsa büyük ihtimalle bir retain cycle vardır (bkz. [Automatic Reference Counting](#26-automatic-reference-counting)).

> [!NOTE]
> Global ya da top level bir değişkende tutulan nesneler program bitene kadar yaşar ve `deinit` mesajları görünmeyebilir. `deinit`'i denerken nesneyi bir fonksiyonun içinde oluşturmak ya da optional bir değişkene atayıp sonra `nil` yapmak gerekir.

### Mülakat soruları

<details>
<summary><b>deinit ne zaman çalışır? Struct'larda neden yok?</b></summary>

Bir class instance'ına olan güçlü referans sayısı sıfıra düştüğünde, nesne bellekten silinmeden hemen önce ARC tarafından çağrılır. Struct'lar value type'tır. Referans sayılmaz ve her kopya bağımsızdır. "Son kopya ne zaman yok oldu" gibi anlamlı bir an olmadığı için `deinit`'leri yoktur.
</details>

<details>
<summary><b>deinit'te ne tür işler yapılır?</b></summary>

ARC'ın otomatik olarak bırakamadığı kaynaklar temizlenir: `NotificationCenter` observer'larını kaldırmak, bir `Timer`'ı geçersiz kılmak, dosya ya da soket bağlantısını kapatmak, bir aboneliği iptal etmek. Ayrıca debug sırasında bir nesnenin bellekten silinip silinmediğini kontrol etmek için log yazılır.
</details>
