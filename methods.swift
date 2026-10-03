import Foundation

struct Workout {
    let name: String
    var minutes: Int
    var isFinished: Bool = false

    func pace(perKm: Double) -> Double {
        Double(minutes) / perKm
    }

    mutating func extend(by extra: Int) {
        minutes += extra
    }

    mutating func finish() {
        isFinished = true
    }

    // Workout başlangıç haline istediğimiz değerlerle döndürülür.
    mutating func reset() {
        self = Workout(name: name, minutes: 0)
    }

    static func makeQuick(name: String) -> Workout {
        Workout(name: name, minutes: 15)
    }
}

var running = Workout(name: "Running", minutes: 30)
print("Pace: \(running.pace(perKm: 5.0)) min/km")
running.extend(by: 15)
running.finish()
print("\(running.name) - \(running.minutes) - finished: \(running.isFinished)")
running.reset()
print("\(running.name) - \(running.minutes) - finished: \(running.isFinished)")

/*
let değer tipinde olduğu için,
let ile tanımlanan bir struct değişkeninde değişiklik yapamayız.
let swimming = Workout(name: "Swimming", minutes: 45)
swimming.extend(by: 10)
*/

let walk = Workout.makeQuick(name: "Walk")
print("\(walk.name) - \(walk.minutes) - finished: \(walk.isFinished)")

class SessionCounter {
    private(set) var count = 0

    func record() {
        count += 1
    }
}

let counter = SessionCounter()
counter.record()
counter.record()
print("Sessions: \(counter.count)")

/*
count property yalnızca okuma amaçlıdır ve dışarıdan değiştirilemez.
counter.count = 99
*/

struct WeekPlan {
    private var days = ["Rest", "Run", "Yoga", "Muay Thai", "Bike", "Cycle", "Swim"]

    subscript(index: Int) -> String {
        get { days.indices.contains(index) ? days[index] : "Unknown" }
        set { if days.indices.contains(index) { days[index] = newValue } }
    }

    subscript(day name: String) -> Int? {
        days.firstIndex(of: name)
    }
}

var plan = WeekPlan()
print("plan[1]: \(plan[1])")
print("plan[99]: \(plan[99])")
// Etiket kullanmadan tanımlamıştık.
plan[0] = "Stretch"
print("plan[0] after set: \(plan[0])")
// Optional olarak almak istiyoruz, warning olmasın diye String(describing:) ile kullanıyoruz.
print("index of Yoga: \(String(describing: plan[day: "Yoga"]))")
print("index of Boxing: \(String(describing: plan[day: "Boxing"]))")
