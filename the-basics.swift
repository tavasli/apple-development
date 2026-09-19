import Foundation

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
