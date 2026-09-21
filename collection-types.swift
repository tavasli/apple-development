import Foundation

var weeklyWorkouts = ["Running", "Cycling", "Yoga"]
// Sona ekleyelim.
weeklyWorkouts.append("Swimming")
// Başa ekleyelim.
weeklyWorkouts.insert("Warmup", at: 0)

for (index, workout) in weeklyWorkouts.enumerated() {
    print("\(index + 1). \(workout)")
}

/*
print(weeklyWorkouts[10])
Index out of range hatası, çünkü böyle bir index değeri yok.
*/

if weeklyWorkouts.indices.contains(10) {
    print(weeklyWorkouts[10])
} else {
    print("No workout at index 10")
}

let mondayTags: Set<String> = ["cardio", "legs", "cardio"]
let tuesdayTags: Set<String> = ["core", "legs"]

// Tekrarlayan değerleri saymadığı için 2 verir.
print("Monday tags: \(mondayTags.count)")
print("Union: \(mondayTags.union(tuesdayTags).sorted())")
print("Intersection: \(mondayTags.intersection(tuesdayTags).sorted())")
// Kümelerdeki A - B gibi düşün.
print("Only Monday: \(mondayTags.subtracting(tuesdayTags).sorted())")

var caloriesByWorkout = ["Running": 300, "Cycling": 250]
caloriesByWorkout["Swimming"] = 400

if let running = caloriesByWorkout["Running"] {
    print("Running burns \(running) kcal")
}

print("Rowing burns \(caloriesByWorkout["Rowing", default: 0]) kcal")
// Dictionary değerini siler.
caloriesByWorkout["Cycling"] = nil
print("Remaining: \(caloriesByWorkout.count)")

for (key, value) in caloriesByWorkout.sorted(by: { $0.key < $1.key }) {
    print("\(key): \(value)")
}

// Value type olduğu için kopyalanır, bağımsızdır.
var copiedWorkouts = weeklyWorkouts
copiedWorkouts.append("Rowing")
print("Original: \(weeklyWorkouts.count)")
print("Copy: \(copiedWorkouts.count)")
