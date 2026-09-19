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
