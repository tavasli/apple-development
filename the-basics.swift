import Foundation

// MARK: - Constants and Variables

// Fitness App - User Profile
let name = "Mustafa TAVASLI"
let birthYear = 2002

var bodyweight: Double = 90
var dailySteps = 12_500

bodyweight = 88

/*
name = "Mustafa"
Hata verir çünkü sabit olarak atanmış bir değeri değiştirmeye çalışıyoruz.
*/

let greeting: String
let hour = Calendar.current.component(.hour, from: Date())
if hour < 12 {
    greeting = "Good Morning"
} else {
    greeting = "Good Night"
}

print(greeting)
print("Name: \(name), Birth Year: \(birthYear), Bodyweight: \(bodyweight), Daily Steps: \(dailySteps)")

// MARK: - Numeric Types

typealias Kilometers = Double
let strideLength = 0.78
let dailyStepsGoal = 10_000
let totalDistance: Kilometers = Double(dailySteps) * strideLength / 1000

/*
var goalProgress = dailySteps / dailyStepsGoal * 100
Yanlış sonuç verir çünkü bize her zaman bir ondalık kısmı atılmış değeri verecektir.
Ayrıca dailySteps, dailyStepsGoal değerinden az olsaydı direkt 0 sonucu verilirdi.
*/

let goalProgress = Double(dailySteps) / Double(dailyStepsGoal) * 100
print(Int(goalProgress))
print(Int(goalProgress.rounded()))
// Ondalık kısım .5 ve üzeri ise Int ile rounded fark yaratır.

let isGoalReached = goalProgress >= 100
if isGoalReached {
    print("Congratulations! You've walked \(totalDistance) km.")
} else {
    print("Keep pushing, you're almost there.")
}

// MARK: - Tuples

let lastWorkout = (type: "Running", durationMinutes: 35, calories: 300)
print(lastWorkout.calories)
print(lastWorkout.1)
// İsimle erişmek kodun anlaşılabilirliği açısından daha doğru olur.

let (type, _, calories) = lastWorkout
print(type)
print(calories)

func activitySummary(stepsCount: Int) -> (distance: Kilometers, goalProgress: Double) {
    let distance: Kilometers = Double(stepsCount) * strideLength / 1000
    let goalProgress = Double(stepsCount) / Double(dailyStepsGoal) * 100
    return (distance, goalProgress)
}

let firstActivity = activitySummary(stepsCount: dailySteps)
let secondActivity = activitySummary(stepsCount: 7000)
print(firstActivity.distance)
print(secondActivity.goalProgress)

let firstWorkout = (calories: 300, durationMinutes: 70)
let secondWorkout = (calories: 300, durationMinutes: 50)
print(firstWorkout < secondWorkout)

/*
Gerçek bir uygulamada böyle bir yapı tuple değil Struct olarak tanımlanırdı.
Verilerin fonksiyon dışında kullanılacağı, protocol conformance gibi nedenlerden dolayı tuple yetersiz kalırdı.
*/

// MARK: - Optionals

let weightInput = "88"
let heightInput = "1.80"
let stepsInput = "12500"
// Textfield her zaman String tipinde değer verir.

let steps = Int(stepsInput)
/*
print(steps)
Optional() tipinde bir sonuç getirdi çünkü String içerisi her zaman Int() dönüşümüne uymayabilir.
*/

if let steps {
    print("Steps: \(steps)")
} else {
    print("Invalid steps input")
}

if let weight = Double(weightInput), let height = Double(heightInput), height > 0 {
// Tek satırda dönüşümlerin değerinin optional kontrolü yapılıyor.
    let bmi = weight / (height * height)
    print("BMI: \(bmi)")
} else {
    print("Invalid weight or height")
}

let nickname: String? = nil
print("Welcome, \(nickname ?? name)!")

/*
Bir değerin okunamaması, yani nil olması, ile 0 arasında fark vardır.
Sıfır bir değerdir ve o değişkenin bir değeri olduğunu ifade eder.
nil ise değerin hiç olmadığını belirtir.
Kullanıcıya bir varsayılan değer göstermek doğru bir yaklaşım değildir.
Doğru olan kullanıcıya verinin olmadığını doğru biçimde ifade etmektir.
*/
