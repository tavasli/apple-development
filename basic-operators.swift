import Foundation

let totalMinutes = 135
let hours = totalMinutes / 60
let minutes = totalMinutes % 60
print("Duration: \(hours)h \(minutes)m")

var weeklySteps = 0
weeklySteps += 8_000
weeklySteps += 12_500
weeklySteps += 9_200
print("Weekly steps: \(weeklySteps)")

let dailyGoal : Double = 10_000
let weeklyAverageSteps = Double(weeklySteps) / 3
print("Average: \(weeklyAverageSteps) - " + (weeklyAverageSteps >= dailyGoal ? "Above goal" : "Below goal"))

let restingHeartRate = 72
let isNormal = (60...100).contains(restingHeartRate)
print("Resting heart rate is normal: \(isNormal)")

let workoutDays = ["Mon", "Tue", "Wed", "Thu", "Fri"]
// ... kullansaydık index out of range olurdu, çökerdi.
for i in 0..<workoutDays.count {
    print("Day \(i+1): \(workoutDays[i])")
}

let hasHealthKitPermission = false
let isPremiumUser = true
if hasHealthKitPermission && isPremiumUser {
    print("Syncing...")
} else {
    print("Sync unavailable")
}

print(hasHealthKitPermission && workoutDays[10] == "Sat")
/*
Uygulamayı çökertmez çünkü Swift soldan sağa işlem yapar.
İlk kısım zaten false olduğu için ikinci kısma hiç bakmaz, index hatası olsa bile.
*/
