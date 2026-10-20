# Automatic Reference Counting (ARC)

** Swift, class nesnesi için ona işaret eden (weak olmayan) referansların sayısını tutar. Bu sayı sıfıra indiğinde nesne silinir ve deinit çalışır.

** Struct ve enum değer tipli oldukları için bu olay yoktur.

## Retain Cycle

** ARC çözemediği durumdur. Buna örnek olarak aşağıdaki durum incelendiğinde, iki nesne birbirini tuttuğu için ikisi de serbest kalamaz.

class Owner { var pet: Pet? }
class Pet   { var owner: Owner? }

do {
    let o = Owner(name: "Ali")
    let pet = Pet(name: "Kedi")
    o.pet = pet
    pet.owner = o
}

## weak

** Bu durumu çözen komuttur. Mutlaka var ve optional kullanılmalıdır.
** Sadece class ile kullanılır.

class Pet2 {
    weak var owner: Owner2?
}

## unowned

** Anlamak için şöyle düşün: Bir müşterinin bir kredi kartı olmayabilir (weak/optional) fakat bir kredi kartı bir müşteriye ait olmak zorundadır. (unowned)

** Nesne silindiğinde erişimi çökertir. O yüzden weak kullan, duruma göre tekrar bakarsın.

## Closure Retain Cycle

** En tehlikeli yer burasıdır, sebebi de aşağıdaki örnekte anlaşılıyor.
** Closure içerisinde self kullanıldığı için nesneyi tutuyor, nesne de selfi tutuyor.

class ViewModel {
    var name = "VM"
    var onUpdate: (() -> Void)?

    func setupBad() {
        onUpdate = { print(self.name) }
    }
    deinit { print("ViewModel deinit") }
}

** Çözümü capture list kullanmaktır.

func setupGood() {
    onUpdate = { [weak self] in
        print(self?.name ?? "-")
    }
}

** Artık zayıf yakalama var ve optional oldu. Bu yüzden genelde guard let ile kullanılır.

onUpdate = { [weak self] in
    guard let self else { return }
    // burada self normal, zincirleme ?. yazmana gerek yok
}

** Eğer ki closure saklanıyor ve self yakalnıyorsa bunu kullan, yoksa gerek yok.

# Memory Safety

** Swift sadece ARC değil erişim çakışmalarını da engeller. Aşağıdaki örnekte a hem self hem inout verilen parametreyi belirtiyor, bu da derlemede hata veriyor.

struct Player {
    var health = 10
    mutating func share(with other: inout Player) { other.health += health }
}

var a = Player()
a.share(with: &a)
// error: inout arguments are not allowed to alias each other

# Nested Types

** Bir tipin başka bir tip içerisinde tanımlanabilmesidir. Kapsama uygun bir isimlendirme yapmak için tercih edilebilir, temiz okunur.

struct Workout {
    enum Kind: String { case run, swim }
    struct Interval { let minutes: Int }

    let kind: Kind
    let intervals: [Interval]
}

let w = Workout(kind: .run, intervals: [Workout.Interval(minutes: 5)])
