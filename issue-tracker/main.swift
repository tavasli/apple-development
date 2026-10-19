import Foundation

var taskRepo = IssueRepository<Task>()
var bugRepo = IssueRepository<Bug>()

taskRepo.add(Task(title: "Write report", priority: .high, estimatedTime: 3))
taskRepo.add(Task(title: "Meeting report", priority: .critical, estimatedTime: 1))
bugRepo.add(Bug(title: "Crash on login", priority: .critical, severity: .blocker, affectedVersion: "v2.4.0"))
bugRepo.add(Bug(title: "watchOS UI overflow", priority: .high, severity: .major, affectedVersion: "v2.4.1"))
print(taskRepo.count)
print(bugRepo.count)

if let found = taskRepo.find(where: { $0.priority == .critical }) {
    print(found.summary)
    try taskRepo.delete(id: found.id)
}

print(taskRepo.count)

do {
    try bugRepo.delete(id: UUID())
} catch let error as RepositoryError {
    print(error.localizedDescription)
} catch {
    print("Unexpected: \(error)")
}
