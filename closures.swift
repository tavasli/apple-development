import Foundation

let workoutNames = ["Running", "Yoga", "Cycling", "Swim"]

// Parametreleri belirterek tam halini yazalım.
print(workoutNames.sorted(by: {(a: String, b: String) -> Bool in
    return a.count < b.count
}))
// $ ile kısa arguman belirtebiliriz.
print(workoutNames.sorted(by: { $0.count < $1.count }))
// Son parametre closure olduğu için parantez dışına çıkar.
print(workoutNames.sorted { $0.count < $1.count })

let durations = [30, 45, 60, 20]

// Elemanları özel bir formata çevirelim.
print(durations.map { "\($0) min" })
// Koşulu sağlayan elemanları alalım.
print(durations.filter { $0 > 30 })
// Elemanları bir işleme tabi tutarak teke indirgeyelim.
print("Total: \(durations.reduce(0, +)) min")
// Zincirleme olarak kullanalım.
print("Doubled long workouts: \(durations.filter { $0 > 30 }.map { $0 * 2 }.reduce(0, +))")

func makeStepCounter() -> (Int) -> Int {
    var sum = 0
    return { steps in
        sum += steps
        return sum
    }
}

let counter = makeStepCounter()
// 1000
print("Counter: \(counter(1000))")
// 1500
print("Counter: \(counter(500))")

let counter2 = makeStepCounter()
// 2000
print("Counter 2: \(counter2(2000))")

var pendingTasks: [() -> Void] = []

func schedule(_ task: @escaping () -> Void) {
    pendingTasks.append(task)
}

schedule { print("Sync started") }
schedule { print("Sync finished") }

print("Running \(pendingTasks.count) tasks...")

for task in pendingTasks {
    task()
}

func process(_ values: [Int], with transform: (Int) -> Int) -> [Int] {
    return values.map { transform($0) }
}

// Trailing closure ile her değeri 10 artıralım.
print(process(durations) { $0 + 10 })

// Önceden tanımlı fonksiyonu kullanalım.
func double(_ value: Int) -> Int { value * 2 }
print(process(durations, with: double))
