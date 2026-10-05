import Foundation

struct Workout {
    let name: String
    var minutes: Int
    var note: String?

    init(name: String, minutes: Int) {
        self.name = name
        self.minutes = minutes
    }

    init(quick name: String) {
        self.init(name: name, minutes: 15)
    }
}

let workout1 = Workout(name: "Morning Run", minutes: 30)
let workout2 = Workout(quick: "Evening Yoga")
print("\(workout1.name) - \(workout1.minutes) min - note: \(workout1.note ?? "nil")")
print("\(workout2.name) - \(workout2.minutes) min - note: \(workout2.note ?? "nil")")

struct Email {
    let value: String

    init?(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.contains("@"), !trimmed.hasPrefix("@"), !trimmed.isEmpty else {
            return nil
        }
        value = trimmed
    }
}

let rawEmails = ["  ali@example.com ", "nope", "@x.com"]
for raw in rawEmails {
    if let email = Email(raw) {
        print("Valid: \(email.value)")
    } else {
        print("Invalid: \(raw)")
    }
}

class Session {
    let id: Int
    var label: String

    init(id: Int, label: String) {
        self.id = id
        self.label = label
    }

    convenience init(id: Int) {
        self.init(id: id, label: "Session \(id)")
    }

    deinit {
        print("Session \(id) ended")
    }
}

do {
    let session = Session(id: 1)
    print(session.label)
}
print("After block")

class Activity {
    var name: String

    init(name: String) {
        self.name = name
    }
}

class TimedActivity: Activity {
    var minutes: Int

    init(name: String, minutes: Int) {
        self.minutes = minutes
        // Üst sınıfa erişmeden önce tüm özellikler başlatılmalıdır.
        super.init(name: name)
    }
}

let timedActivity = TimedActivity(name: "Cycling", minutes: 45)
print("\(timedActivity.name) - \(timedActivity.minutes) min")

struct AppSettings {
    var launchedAt: Date = {
        let date = Date(timeIntervalSince1970: 0)
        print("App launched at: \(date)")
        return date
    }()
}

let appSettings = AppSettings()

struct Point {
    var x = 0.0
    var y = 0.0

    // Tüm durumları kapsayabilen bir init() bu şekilde yazılır.
    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
}

let point1 = Point(x: 1, y: 2)
let point2 = Point()
