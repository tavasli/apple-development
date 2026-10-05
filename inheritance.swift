import Foundation

class Activity {
    var name: String
    var minutes: Int

    init(name: String, minutes: Int) {
        self.name = name
        self.minutes = minutes
    }

    var summary: String {
        "\(name) - \(minutes) min"
    }

    func describe() -> String {
        "Activity: \(summary)"
    }
}

class Run: Activity {
    var distanceKm: Double

    init(name: String, minutes: Int, distanceKm: Double) {
        self.distanceKm = distanceKm
        super.init(name: name, minutes: minutes)
    }

    // super.summary üst sınıfın halini verir, üstüne mesafeyi ekliyoruz.
    override var summary: String {
        "\(super.summary) - \(distanceKm) km"
    }

    override func describe() -> String {
        "Run: \(summary)"
    }
}

final class TrailRun: Run {
    var elevation: Int = 300

    override func describe() -> String {
        "TrailRun(+\(elevation)m): \(summary)"
    }
}

let activities: [Activity] = [
    Activity(name: "Cycling", minutes: 90),
    Run(name: "Running", minutes: 60, distanceKm: 10.0),
    TrailRun(name: "Trail Run", minutes: 75, distanceKm: 8.0)
]

// Dizinin tipi [Activity] ama her nesne kendi describe() metodunu çalıştırır.
for activity in activities {
    print(activity.describe())
}

for activity in activities {
    if activity is Run {
        print("Is a run: \(activity.name)")
    }

    // as? optional döndürür; açınca Run'a özel üyelere erişilebilir.
    if let run = activity as? Run {
        print("Distance: \(run.distanceKm) km")
    } else {
        print("Not a run: \(activity.name)")
    }
}

// Özel durum (TrailRun) genel durumdan (Run) önce yazılmalı.
// Ters sırada TrailRun case'ine hiç sıra gelmez, çünkü TrailRun aynı zamanda bir Run'dır.
for activity in activities {
    switch activity {
    case let trail as TrailRun:
        print("Trail run with \(trail.elevation) m elevation")
    case let run as Run:
        print("Run of \(run.distanceKm) km")
    default:
        print("Plain activity: \(activity.name)")
    }
}

let someRun = Run(name: "Evening Run", minutes: 30, distanceKm: 6.0)
let mixed: [Any] = [1, "Mustafa", 42.0, false, someRun]

for thing in mixed {
    switch thing {
    case let intValue as Int:
        print("Int: \(intValue)")
    case let stringValue as String:
        print("String: \(stringValue)")
    case let doubleValue as Double:
        print("Double: \(doubleValue)")
    case let boolValue as Bool:
        print("Bool: \(boolValue)")
    case let activity as Activity:
        print("Activity: \(activity.name)")
    default:
        print("Other")
    }
}

/*
 as! zorla dönüşüm yapar ve optional döndürmez, bu yüzden if let ile kullanılamaz.
 activities[0] bir Activity olduğu için aşağıdaki satır çalışma anında çöker:
 Could not cast value of type 'Activity' to 'Run'

 let forced = activities[0] as! Run
 print(forced.distanceKm)
 */
