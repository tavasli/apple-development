import Foundation

class Address {
    var city: String?
    var street = "Main St."

    init(city: String?) {
        self.city = city
    }

    func label() -> String {
        "\(street), \(city ?? "-")"
    }

    subscript(line: Int) -> String {
        "line \(line)"
    }
}

class Profile {
    var address: Address?

    init(address: Address?) {
        self.address = address
    }
}

class User {
    var profile: Profile?

    init(profile: Profile?) {
        self.profile = profile
    }
}

let full = User(profile: Profile(address: Address(city: "Istanbul")))
let empty = User(profile: nil)

print(String(describing: full.profile?.address?.city))
print(String(describing: empty.profile?.address?.city))
print(String(describing: full.profile?.address?.street))
print(String(describing: full.profile?.address?.label()))
print(String(describing: empty.profile?.address?.label()))
print(String(describing: full.profile?.address?[2]))

print("City: \(full.profile?.address?.city ?? "unknown")")
print("City: \(empty.profile?.address?.city ?? "unknown")")

full.profile?.address?.city = "Ankara"
print("Updated city: \(full.profile?.address?.city ?? "unknown")")

empty.profile?.address?.city = "Izmir"
print("No crash on nil chain")

let scores: [String: [Int]] = ["ali": [3, 5]]
print(String(describing: scores["ali"]?[1]))
print(String(describing: scores["veli"]?[0]))
print(String(describing: scores["ali"]?.count))

enum SyncError: Error, LocalizedError {
    case offline
    case server(code: Int)
    case notFound(id: Int)

    var errorDescription: String? {
        switch self {
        case .offline:
            "No internet connection."
        case .server(let code):
            "Server error (\(code))."
        case .notFound(let id):
            "Record \(id) was not found."
        }
    }
}

func fetch(id: Int) throws -> String {
    if id == 0 { throw SyncError.offline }
    if id < 0 { throw SyncError.server(code: 500) }
    if id == 99 { throw SyncError.notFound(id: id) }
    return "data-\(id)"
}

func load(id: Int) throws -> String {
    let raw = try fetch(id: id)
    return raw.uppercased()
}

for id in [1, 0, -1, 99] {
    do {
        let value = try load(id: id)
        print("Loaded: \(value)")
    } catch SyncError.offline {
        print("Offline, try again later.")
    } catch let error as SyncError {
        print("Sync failed: \(error.localizedDescription)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

print(String(describing: try? fetch(id: 5)))
print(String(describing: try? fetch(id: 0)))

func loadWithCleanup(id: Int) throws -> String {
    print("Opening connection")
    defer { print("Closing connection") }
    return try fetch(id: id)
}

do {
    let value = try loadWithCleanup(id: 3)
    print("Result: \(value)")
} catch {
    print("Failed: \(error.localizedDescription)")
}

do {
    let value = try loadWithCleanup(id: 0)
    print("Result: \(value)")
} catch {
    print("Failed: \(error.localizedDescription)")
}

func resultFetch(id: Int) -> Result<String, SyncError> {
    id > 0 ? .success("data-\(id)") : .failure(.offline)
}

for id in [7, 0] {
    switch resultFetch(id: id) {
    case .success(let value):
        print("Result success: \(value)")
    case .failure(let error):
        print("Result failure: \(error.localizedDescription)")
    }
}
