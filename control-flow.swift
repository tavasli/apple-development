import Foundation

for i in stride(from:0, through:60, by:15) {
    print(i, terminator: " ")
    // terminator parametresi ile aynı satırda çıktı verdik.
}

print("")

func heartRateZone(bpm: Int) -> String {
    switch bpm {
    case 0..<60:
        return "Low"
    case 60..<100:
        return "Resting"
    case 100...150:
        return "Cardio"
    case 151...:
        return "Max"
    default:
        return "Heart rate is not valid."
    }
}

print("55 bpm: \(heartRateZone(bpm: 55))") 
print("72 bpm: \(heartRateZone(bpm: 72))") 
print("130 bpm: \(heartRateZone(bpm: 130))") 
print("175 bpm: \(heartRateZone(bpm: 175))")

func describeWorkout(_ workout: (type: String, minutes: Int)) -> String {
    switch workout {
        case (_, 0):
            return "Not started"
        case ("Running", let minutes) where minutes > 60:
            return "Long run: \(minutes) min"
        case ("Running", let minutes):
            return "Run: \(minutes) min"
        default:
            return "\(workout.type): \(workout.minutes) min"
    }
}

// _ ile atandığı için parametre isimlerini belirtmeye gerek yok.
print(describeWorkout(("Running", 0)))
print(describeWorkout(("Running", 75)))
print(describeWorkout(("Running", 30)))
print(describeWorkout(("Yoga", 45)))

let weekPlan = [["Rest", "Running"], ["Yoga", "Stop"], ["Cycling", "Swimming"]]

outer: for day in weekPlan {
    for activity in day {
        if activity == "Rest" { continue }
        if activity == "Stop" { break outer}
        print(activity)
    }
}

let readings: [Int?] = [72, nil, 85, nil, 91]

for case let value? in readings {
    print(value, terminator: " ")
}

print("")

var remaining = 3

repeat {
    remaining -= 1
    print("Sets remaining: \(remaining)")
} while remaining > 0
