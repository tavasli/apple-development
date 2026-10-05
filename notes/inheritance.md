# Inheritance

** Bir class başka bir class içerisindeki property ve methodları devralabilir.
** Yalnızca class için geçerlidir.
** Kullanılan class superclass, kullanan class subclass olur.

## override

** Subclass içerisinde superclass ait bir property veya method değiştirilebilir. Bu değişim yalnızca bu class için geçerlidir, diğerinde aynı kalır.

** Superclass içerisindeki stored property observer eklemek güzel bir yaklaşımdır. Aşağıda örneği bulabilirsin.

class LoggingCounter: Counter {
    override var value: Int {
        didSet { print("value -> \(value)") }
    }
}

## dynamic dispatch

** Bir dizi superclass tipinde değerler barındıracaksa subclass eklemesi de yapılabilir. Burada hepsinde ortak bulunan ama override edilmiş bir method çağrıldığında ise hepsi farklı çıktıyı verebilir. Buna da polimorfizm denir.

## final

** final ile tanımlanmış sınıf veya methodlar üzerine değişiklik yapılamaz. Kalıtım oluşturmayı düşünmediğimiz class için bu şekilde tanımlamak iyidir. Ayrıca dinamik olmayacağı için daha hızlı derlenir.

** Swift yaklaşım olarak inheritance değil composition ağırlıklıdır. Bunu da protocol ile sağlarız, orada göreceğiz.

# Type Casting

** is: "Bu mu" kontrolü yapar.
** as?: "Bu aslında şu" diyebiliriz. Optional olduğu için orada öğrendiklerimiz uygulanır. Çok sık kullanılır.
** as!: "Bu kesin şu" der. Tercih etmemek daha iyidir.
** as: Bir alt sınıf nesneyi üst sınıf olarak almak isteyince kullanabiliriz. Hata veremez.

** Switch ile kullanıldığında özelden genele şeklinde gitmek zorundayız, yoksa genel her türlü baskın geleceği için yanlış olur.

for item in items {
    switch item {
    case let trail as TrailRun: print("trail \(trail.elevation)")
    case let run as Run:        print("run \(run.distanceKm)")
    default:                    print("plain \(item.name)")
    }
}

** Any: Her tipi alabilir.
** AnyObject: Class örneklerini alabilir.
** Tip güvenliğini kaybettirecekleri için kaçınılır, generics kısmında daha doğru yaklaşımları göreceğiz.
