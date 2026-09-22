import Foundation

// implicit return olduğu için tek satırda yazabiliriz.
func summary(for workout: String, duration minutes: Int = 30) -> String { "\(workout) - \(minutes) min" }

print(summary(for: "Running"))
print(summary(for: "Cycling", duration: 75))

// Matematiksel işlemlerde argument label vermeye gerek duymayabiliriz.
func pace(_ minutes: Double, _ kilometers: Double) -> Double { minutes / kilometers }

print("Pace: \(pace(30, 5)) min/km")

// ... ile değişken sayıda parametre alınabilir.
func totalCalories(_ values: Int...) -> Int {
    var sum = 0
    for value in values {
        sum += value
    }

    return sum
}

print("Total: \(totalCalories(300, 250, 400))")
print("Total: \(totalCalories())")

func range(of values: [Int]) -> (min: Int, max: Int)? {
    // guard ile hem değer var mı kontrolü hem de varsa onu alma işlemi yapabiliriz.
    guard let minimum = values.min(), let maximum = values.max() else { return nil }
    return (minimum, maximum)
}

if let result = range(of: [72, 85, 91]) {
    print("Min: \(result.min), Max: \(result.max)")
} else {
    print("No readings")
}

if let result = range(of: []) {
    print("Min: \(result.min), Max: \(result.max)")
} else {
    print("No readings")
}


func addSet(to count: inout Int) {
    count += 1
}

var completedSets = 2
addSet(to: &completedSets)
addSet(to: &completedSets)
print("Completed sets: \(completedSets)")

func isAboveTenThousand(_ steps: Int) -> Bool {
    // ternary gibi çalışıp kontrol sağlar, bool döner.
    return steps > 10_000
}

func applyGoal(_ rule: (Int) -> Bool, to steps: Int) -> String {
    if rule(steps) {
        return "Goal reached"
    } else {
        return "Keep going"
    }
}

print(applyGoal(isAboveTenThousand, to: 12_500))
print(applyGoal(isAboveTenThousand, to: 8_000))
