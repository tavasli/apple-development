import Foundation

let testInputs = [
    "add 250,50 food Lunch at work",
    "add 12 transport Metro",
    "list",
    "delete 2",
    "adfd 250 food Test",
    "add 250",
    "add abc food Test",
    "add 250 spaceship Test",
    "delete two",
    ""
]

for input in testInputs {
    do {
        let command = try parse(input: input)
        print("OK: \(command)")
    } catch let error as CommandError {
        print("ERROR: \(error.message)")
    } catch {
        print("UNEXPECTED: \(error)")
    }
}
