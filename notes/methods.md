# Methods & Subscripts

## Instance Method

** Method, tipe bağlı fonksiyondur.
** Bir method propertylere erişirken doğrudan bunu yapabilir. self kullanma gereği sadece parametre ve property aynı isimde olduğunda olur.

## mutating

** Struct bir değer olduğu için bir property değerini değiştirmek istediğimiz fonksiyonun tanımlanmasında bunu kullanmamız gerekir.
** let ile kullanılamaz. Class için mutating yoktur, zaten let olsa bile içi değişebileceği için gereksizdir.

## static ve class

** static ile tanımlanan methodlar tipin kendisine aittir. Alt class içerisinde override edilemez.
** class ile tanımlanan methodlar alt class içerisinde override edilebilir.
** Inheritance kısmında daha net anlaşılacak.

## private(set)

** Dışarıdan okuma için erişilebilir, fakat yazma işlemi yapılamaz.
** Gerçek senaryolarda çok sık kullanılır. Kullanıcıya bir şeyleri okuyabilmesi ama müdahale edememesi sağlanır.

## Subscripts

** Kısayol olmakla beraber bir güvenlikte oluşturmak için kullanılabilir. Burada uygulamanın çökmesinden ziyade "Unknown" değer verilmesini sağlar.
** Çok sık tercih edilen bir şey değildir.

subscript(index: Int) -> String {
    get { days.indices.contains(index) ? days[index] : "Unknown" }
    set { if days.indices.contains(index) { days[index] = newValue } }
}
