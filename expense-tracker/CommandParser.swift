import Foundation

enum Command {
    case add(title: String, amount: Decimal, category: Category)
    case list
    case report
    case delete(position: Int)
    case help
    case quit
}

enum CommandError: Error {
    case emptyInput
    case unknownCommand(String)
    case missingArguments(expected: Int)
    case invalidAmount(String)
    case invalidPosition(String)
    case unknownCategory(String)

    var message: String {
        switch self {
        case .emptyInput:
            return "No command entered. Please enter a command."
        case .unknownCommand(let command):
            return "Unknown command: '\(command)'. Type 'help' for a list of commands."
        case .missingArguments(let expected):
            return "Missing arguments. Expected \(expected) arguments."
        case .invalidAmount(let amount):
            return "Invalid amount: '\(amount)'. Please enter a valid decimal number."
        case .invalidPosition(let position):
            return "Invalid position: '\(position)'. Please enter a valid integer."
        case .unknownCategory(let category):
            return "Unknown category: '\(category)'. Valid: \(Category.allCases.map { $0.rawValue }.joined(separator: ", "))"
        }
    }
}

func parse(input: String) throws -> Command {
    let trimmed = input.trimmingCharacters(in: .whitespaces)
    let components = trimmed.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
    guard let commandString = components.first else {
        throw CommandError.emptyInput
    }

    switch commandString.lowercased() {
    case "add":
        guard components.count >= 4 else {
            throw CommandError.missingArguments(expected: 3)
        }
        let amountText = String(components[1])
        guard let amount = Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) else {
            throw CommandError.invalidAmount(amountText)
        }
        guard let category = Category(rawValue: String(components[2]).lowercased()) else {
            throw CommandError.unknownCategory(String(components[2]))
        }
        let title = String(components[3]).trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else {
            throw CommandError.missingArguments(expected: 3)
        }
        return .add(title: title, amount: amount, category: category)

    case "list":
        return .list

    case "report":
        return .report

    case "delete":
        guard components.count >= 2 else {
            throw CommandError.missingArguments(expected: 1)
        }
        guard let position = Int(components[1]) else {
            throw CommandError.invalidPosition(String(components[1]))
        }
        return .delete(position: position)

    case "help":
        return .help

    case "quit":
        return .quit

    default:
        throw CommandError.unknownCommand(String(commandString))
    }
}
