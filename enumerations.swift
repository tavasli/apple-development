import Foundation

enum WorkoutType {
    case running
    case cycling
    case yoga
    case swimming
}

func emoji(for type: WorkoutType) -> String {
    switch type {
    case .running: "\(type) 🏃🏻"
    case .cycling: "\(type) 🚴🏻"
    case .yoga: "\(type) 🧘🏻"
    case .swimming: "\(type) 🏊🏼"
    }
}

let workouts: [WorkoutType] = [.running, .cycling, .yoga, .swimming]
for workout in workouts {
    print(emoji(for: workout))
}

enum Intensity: String, CaseIterable {
    case low, medium, high
}

print(Intensity.allCases.map(\.rawValue))

let incoming = ["high", "extreme"]
for value in incoming {
    if let parsed = Intensity(rawValue: value) {
        print("Parsed: \(parsed.rawValue)")
    } else {
        print("Unknown intensity: \(value)")
    }
}

enum LoadState {
    case idle
    case loading(progress: Double)
    case loaded([String])
    case failed(String)
}

func describe(_ state: LoadState) -> String {
    switch state {
    case .idle:
        "Waiting"
    case .loading(let progress):
        "Loading \(Int(progress * 100))%"
    case .loaded(let workouts) where workouts.isEmpty:
        "No workouts"
    case .loaded(let workouts):
        "Loaded \(workouts.count) workouts"
    case .failed(let message):
        "Error: \(message)"
    }
}

let states: [LoadState] = [
    .idle,
    .loading(progress: 0.4),
    .loaded([]),
    .loaded(["Running", "Yoga"]),
    .failed("offline")
]

for state in states {
    print(describe(state))
}

enum Zone: Int, CaseIterable {
    case rest = 1, fat, cardio, peak

    var label: String {
        switch self {
        case .rest: "Rest"
        case .fat: "Fat burn"
        case .cardio: "Cardio"
        case .peak: "Peak"
        }
    }

    func isHard() -> Bool {
        rawValue >= 3
    }
}

for zone in Zone.allCases {
    print("\(zone.rawValue) - \(zone.label) (hard: \(zone.isHard()))")
}
