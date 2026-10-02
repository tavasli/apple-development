import Foundation

struct Workout {
    let name: String
    var minutes: Int
    var caloriesPerMinute: Double

    var hours: Double {
        Double(minutes) / 60.0
    }

    var totalCalories: Double {
        Double(minutes) * caloriesPerMinute
    }

    var summary: String {
        "\(name) - \(minutes) min - \(hours) h - \(totalCalories) kcal"
    }

    var durationInHours: Double {
        get { hours }
        set { minutes = Int(newValue * 60) }
    }
}

let running = Workout(name: "Run", minutes: 95, caloriesPerMinute: 7.5)
print(running.summary)

var cycling = Workout(name: "Cycle", minutes: 120, caloriesPerMinute: 8.0)
// durationInHours kullanarak minutes değiştirdik.
cycling.durationInHours = 2
print(cycling.minutes)

class WorkoutHistory {
    init() {
        print("History loaded")
    }

    func load() -> [String] {
        ["Run", "Yoga"]
    }
}

class Dashboard {
    lazy var history = WorkoutHistory()
    var title = "Dashboard"
}

let dashboard = Dashboard()
print("Dashboard ready")
print(dashboard.history.load())

class StepTracker {
    var steps: Int = 0 {
        didSet {
            print("Steps: \(oldValue) -> \(steps)")
            // Tam geçtikten sonra yazmak için iki koşul verdik.
            if oldValue < 10_000 && steps >= 10_000 {
                print("Goal reached!")
            }
        }
    }
}

let stepTracker = StepTracker()
stepTracker.steps = 5_000
stepTracker.steps = 9_000
stepTracker.steps = 12_000
stepTracker.steps = 15_000

struct TrackerConfig {
    static let appName = "Tracker"
    static let dailyGoal = 10_000
    static var sessionCount = 0
    static var summary: String {
        "\(appName) - goal: \(dailyGoal) - \(sessionCount) sessions"
    }
}

TrackerConfig.sessionCount += 2
print(TrackerConfig.summary)

@propertyWrapper
struct NonNegative {
    private var value: Int

    var wrappedValue: Int {
        get { value }
        set { value = max(0, newValue) }
    }
    // init oluşturarak bana doğrudan bir Int verirsen onu kendim sararım demesi lazım. 
    // wrappedValue parametresi özeldir, Swift bunu bekler.
    init(wrappedValue: Int) {
        self.value = max(0, wrappedValue)
    }
}

struct DailyStats {
    @NonNegative var steps: Int
    @NonNegative var activeMinutes: Int
}

var stats = DailyStats(steps: -500, activeMinutes: 45)
print("Steps: \(stats.steps)\nActive Minutes: \(stats.activeMinutes)")
