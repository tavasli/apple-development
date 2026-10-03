# Structs & Classes

Ortak Noktalar:
- Property
- Metod
- init() ile tanımlanma
- Extensions ile genişletme
- Protocol'e uyma

** Struct için bir init() yazılmasına gerek yoktur. Swift, memberwise init oluşturur. Class için ise init() yazılmak zorundadır. self komutu ile parametre ve property aynı isimlendirildiğinde ayırmak için kullanılır.

** Struct bir value type, Class ise reference type.
** Şöyle düşün, bir değişken struct atandığında değeri tutar; class atandığında ise ok ile nesneyi işaret eder.

** let kullanımı ikisinde önemli bir ayrıma uğrar.
** Struct let ile tanımlanırsa değerler sabitlenir, değiştirilemez. Class let ile tanımlandığında ise içi değişebilir, ama başka bir ok oluşturulamaz.

** Struct içerisindeki bir metod kendi içerisindeki bir property değişimi yapacaksa mutating komutu ile işaretlenmelidir. Class ise value type olmadığı için gerek yoktur.

** Swift "Copy-on-write" mantığında çalışır. Örneğin çoklu değer tutabilen değişken tiplerini düşündüğünde bunlar işlem yapılana kadar kopyalanmaz.

## Class Özgü Noktalar

- Kalıtım yapılabilir.
- deinit() çalışır.
- ARC: Nesneleri kaç okun gösterdiği bilinir, sıfıra inince silinir. Retain cycle konusunun çıkışı bundandır.
- === ile nesne kontrolü yapılabilir.

## Hangisini Tercih Etmeliyiz?

- Struct: modeller (Workout, User, Trip), SwiftUI View'ları, Codable tipler. Yani neredeyse her şey.
- Class: view model'ler, servisler, manager'lar.

** Struct arkandan değiştirilemeyeceği için rahat kullanırsın. Class ise aynı şekilde çalışmaz, ama daha esnektir. Concurrency olayı da bundan dolayı önemlidir.

** Varsayılan olarak struct kullan. Struct yetmediği durumlara geçtiğinde yapıyı class hale çevir.

### Property ve Metod Seçimi

** Eğer ki basitçe bir işlem yapılacak, değer değiştirilmeyecekse property kullan. Tam tersinde ise metod olarak tanımla.

** var propertyName: Type {} şeklinde ataması yapılır. Kullanırken de function aksine () eklenmez.

** ⚠️ Doğru sonuç, zayıf gerekçe. "Apple öyle tavsiye ediyor" mülakatta yetersiz kalır, hemen "neden tavsiye ediyor?" diye sorarlar. Şöyle cevapla: "Struct'la başlarım çünkü değer semantiği güvenlidir; bir modeli fonksiyona verdiğimde arkamdan değiştirilemeyeceğini bilirim, çok thread'li kodda da sorun çıkarmaz. Class'a ancak kimlik gerekiyorsa, paylaşılan ve değişen bir durum varsa ya da kalıtım gerekiyorsa geçerim." Bunu not al, mock mülakatta tekrar soracağım.

## Expense Tracker

** Bir sınıftan miras alınmayacaksa final class şeklinde oluşturulması optimizasyon için iyidir.

** private ile oluşturulan propertylere sınıf içerisindeki methodlar harici erişilmez.