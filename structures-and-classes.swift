import Foundation

struct Workout {
    var name: String
    var minutes: Int
    var isFinished: Bool = false

    var summary: String {
        "\(name): \(minutes) min"
    }

    // Property değişeceği için mutating kullandık.
    mutating func extend(by extra: Int) {
        minutes += extra
    }
}

let workout = Workout(name: "Running", minutes: 30)

var copy = workout
copy.extend(by: 15)

print("Original: \(workout.summary)")
print("Copy: \(copy.summary)")

let workout2 = Workout(name: "Swimming", minutes: 60, isFinished: true)

/*
workout2.extend(by: 20)
let ile tanımlandığı için kendi değerleri değiştirlemez, hata verir.
*/

class WorkoutSession {
    var name: String
    var minutes: Int

    init(name: String, minutes: Int) {
        self.name = name
        self.minutes = minutes
    }

    // mutating komutu class için gerekli değildir.
    func extend(by extra: Int) {
        minutes += extra
    }

    deinit {
        print("Session ended: \(name)")
    }
}

let workoutSession = WorkoutSession(name: "Cycling", minutes: 100)
print("Session: \(workoutSession.minutes) min")

let sharedSession = workoutSession
sharedSession.extend(by: 15)
print("Original: \(workoutSession.minutes), Shared: \(sharedSession.minutes)")
print("Same object: \(sharedSession === workoutSession)")

func createTempSession() {
    let tempSession = WorkoutSession(name: "Yoga", minutes: 60)
    print("Temp session created: \(tempSession.name)")
}

createTempSession()
print("After function")

//Copy-on-write olma durumunu gösterir.
let arr1: [Int] = [1, 2, 3]
var arr2 = arr1
arr2.append(4)
print(arr2)
print(arr1)
