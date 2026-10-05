# Initialization

** Bir örnek kullanıma hazır hale gelirken bütün stored property'lerinin değeri olduğundan emin olmak. Swift bunu derleme zamanında garanti eder.

** Optional olanları init() içerisinde vermeye gerek yoktur.
** let propertylere init() içerisinde bir kez değer atanabilir, çünkü kurulum aşamasındadır. Sonradan atama olmaz.

** Initializer Delegation: İçerisinde başka bir init() çağrılan custom bir init() methodudur.
** Custom initializer yazıldığında memberwise init kaybolur. Normal init() methodu olmazsa derleme olmaz. Bunu çözmenin yolu da custom init() methodunu bir extensions içerisine koymaktır, sık kullanılan bir yöntemdir.

** Failable Initializer: Kurulum başarısız olabilirse kullanılır. Aşağıdaki örnekten anlayabiliriz.

struct Email {
    let value: String

    init?(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        guard trimmed.contains("@"), !trimmed.hasPrefix("@") else { return nil }
        value = trimmed
    }
}

Email("  a@b.com ")?.value   // Optional("a@b.com")
Email("nope")                // nil

** Bir property varsayılan değeri birkaç satırlık iş gerektiriyorsa closure kullanılır. Hemen sonuna da () eklenerek tanımlanıp çağrılması hemen yapılır.

## designated vs convenience

** designated init: Asıl init() methodudur. Her class bir tane içermelidir. Dikey sınıflar için delege eder.
** convenience init: Kendisi property atamaz, mutlaka bir designated init delege eder. Aynı sınıf içerisinde delege eder.

class Session {
    let id: Int
    var label: String

    init(id: Int, label: String) {        // designated: asıl initializer
        self.id = id
        self.label = label
    }

    convenience init(id: Int) {           // convenience: kolaylık sağlayan
        self.init(id: id, label: "Session \(id)")
    }
}

** Kalıtım yaparken init() methodu içerisinde önce o sınıfa ait property kurulumları yapılır, sonra dikey sınıflar yapılır. Swift bunu zorunlu tutar.

** reuqired init() methodu bütün alt sınıfların bu methodu sağlamasını zorunlu kılar. UIKit içerisinde görülür.

## Deinitialization

** Her class en fazla bir tane içerir. Parametre almaz.
** Son referans yok olduğunda silinmeden önce çalışır. Kontrolü ARC yapar.
** Struct ve enum deinit() içermez çünkü değer tiptedir.
