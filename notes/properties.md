# Properties

** Değer saklanıyor mu her seferinde hesaplanıyor mu?

## Stored Property

** Değeri saklar.
** Bellekte yer tutar.

## Computed Property

** Değeri hesaplar.
** Bellekte yer tutmaz, her erişimde yeniden hesaplanır.

** Buna "single source of truth" denir. Mülakat cevabın şu olmalı: "Biri stored, diğeri computed. Çünkü iki ayrı stored property tutmak aynı bilginin iki kopyasını tutmak demektir ve bunlar zamanla birbirinden ayrışır. Computed property ile türetilmiş değer her zaman kaynakla tutarlı kalır."

## getter - setter

** Computed propertylerde bir işlem yapılır. Mesela örnekte hours için bir minutes dayanağına ihtiyaç vardır, bunun üzerinden işlem yapılır.
** get ile .hours ile değer döndürülür. set ile .hours = 1 gibi bir atama yapılır.
** Sadece get kullanılacaksa get {} yazmaya gerek yoktur, zaten read-only yapıdadır.

var hours: Double {
    get { Double(minutes) / 60 }    // "beni okuyunca ne döndüreyim?"
    set { minutes = Int(newValue * 60) }  // "bana değer atanınca ne yapayım?"
}

## lazy

** Bir değerin erişileceği sırada oluşturulmasıdır. Değerin oluşturulması pahalı bir işlemse ve kullanılmama ihtimali varsa tercih edilir.
** var ile tanımlanmak zorundadır. Thread safe değildir.

## Property Observer

** willSet: Yeni değer henüz atanmadı, property hala eski değeri taşır.
** didSet: Yeni değer atandı, eski değere oldValue ile erişilebilir.
** Değer dışarıdan atandığında çalışır, init içerisindeki atamada çalışmazlar.

## static

** Bu property örneğin kendisine değil tipin kendisine bağlıdır.

struct AppConfig {
    static let appName = "Tracker"
    static var launchCount = 0
    static var summary: String { "\(appName) launched \(launchCount) times" }
}
// AppConfig() oluşturmadan kullanabiliriz.
AppConfig.launchCount += 1
print(AppConfig.summary)

## Property Wrapper

** Aynı mantığın uygulanacağı yerler için tek bir paket yazmak gibidir.
** Yeniden kullanılabilen bir getter-setter diyebiliriz.
** SwiftUI içerisinde kullanılan @ ile işaretlenen her şey buna örnektir. Her yerde karşımıza çıkacaktır.
** Kendi wrapper yazma işlemi nadirdir, önemli olan ne olduğunu bilmektir.

** @State private var count = 0 yazdığında:

@State bir property wrapper'dır, yani Swift'in sıradan bir dil özelliği, SwiftUI'a özgü bir sihir değil.
Derleyici arka planda bir State<Int> örneği oluşturur ve count'a yapılan her okuma/yazmayı onun wrappedValue'sundan geçirir. Yani senin elle yazdığın get/set çiftinin aynısı.
Değerin kendisi View struct'ının içinde değil, SwiftUI'ın yönettiği bir depoda tutulur. Bu önemli: View bir struct ve sürekli yeniden oluşturulur; eğer değer struct'ın içinde olsaydı her çizimde sıfırlanırdı.
Değer değiştiğinde SwiftUI bunu fark eder ve o görünümün gövdesini yeniden hesaplar.
$count ise projectedValue'dur. @State için bu bir Binding<Int>, yani "bu değeri okuyabilir ve yazabilirsin" yetkisini başka bir görünüme devretmenin yolu. TextField("", text: $name) yazdığında metin alanına yetki vermiş olursun.
