# Error Handling

## Optional Chaining

** Pyramid of Doom oluşmasını engellemek için, iç içe geçmiş ama optional durumdaki yapılar sıralanarak kullanılabilir.

** Soldan sağa doğru gidilir, herhangi bir anda nil olursa gerisine bakılmaz. Sonuç nil değilse bile her zaman optional olur.

full.profile?.address?.city     // Optional("Istanbul")
empty.profile?.address?.city    // nil

** Methodlar için de benzer kullanım vardır. Bu sayede aslında çökme yaşamanın önüne geçilerek nil değer verilmesi sağlanır, çünkü method hiç çağrılmamıştır.

empty.profile?.address?.label()  // nil

** Zincir üzerinden bir atama yapılabilir, ama burada atama yapılamıyorsa bile hata alınmaz. Hiçbir şey olmadan devam eder, fark edemeyiz.

full.profile?.address?.city = "Ankara"    // çalışır
empty.profile?.address?.city = "X"        // sessizce hiçbir şey olmaz, çökmez

** ! ile force edilebilir, ama önceki konularda da olduğu gibi olabildiğince bu duruma düşmemek gerekiyor.

## Propagation

** Hatayı onunla ne yapacağını bilen katmanın yakalamasını sağlayan önemli bir tasarım fikridir.

func fetch(id: Int) throws -> String { ... }

func load(id: Int) throws -> String {
    let raw = try fetch(id: id)      // yakalamıyoruz, yukarı taşıyoruz
    return raw.uppercased()
}

** Gerçek projelerde error için kendi enum yapımızı oluşturduğumuzda Swift tarafından standard edilen localizedDescription ile açıklamalara erişebiliriz.

** defer: Ne olursa olsun çalışan bloktur.

** Typed Throws: throws demek bir fonksiyonun hata fırlatabileceğini gösterir. Bunun hangi tipte olabileceğini de verebileceğimiz yeni bir kullanımdır.

func strictFetch(id: Int) throws(SyncError) -> String { }

** Result: Başarı veya hatayı bir değer olarak taşır.
