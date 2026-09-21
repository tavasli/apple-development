import Foundation

// """ ile istediğimiz biçimde metin yazabiliriz.
let workoutSummary = """
Workout: Running
Duration: 35 min
Calories: 300
"""

print(workoutSummary)

let plainE = "é"
let combinedE = "e\u{301}"
let thumbsUp = "👍🏽"

print("\(plainE == combinedE) \(plainE.count) \(combinedE.count) \(thumbsUp.count) \(thumbsUp.unicodeScalars.count)")

let rawEmail = "   ali@example.com   "
let rawName = "    "

let isValid = rawEmail.trimmingCharacters(in: .whitespaces).contains("@")
let isEmpty = rawName.trimmingCharacters(in: .whitespaces).isEmpty

print("Email valid: \(isValid)")
print("Name is \(isEmpty ? "empty" : rawName.trimmingCharacters(in: .whitespaces))")

let fullName = "Mustafa TAVASLI"
if let whiteSpaceIndex = fullName.firstIndex(of: " ") {
    let name = fullName[..<whiteSpaceIndex]
    let tmp = fullName[fullName.index(after: whiteSpaceIndex)...]
    // ... ile sonuna kadar git demek istiyoruz.
    let surname = String(tmp)
    print("First: \(name) (\(type(of: name)))\nLast: \(surname) (\(type(of: surname)))")
}


print("\(fullName.uppercased()) \(fullName.hasPrefix("Mus")) \(fullName.contains("TAV"))")
print("First char: \(fullName[fullName.startIndex]), last char: \(fullName[fullName.index(before: fullName.endIndex)])")
/*
print(fullName[fullName.endIndex])
Çöker, çünkü endIndex son karakterden bir sonrasını işaret eder.
Aslında metnin bitişini diyebiliriz.
*/
