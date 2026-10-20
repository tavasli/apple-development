import Foundation

var taskRepo = IssueRepository<Task>()
var bugRepo = IssueRepository<Bug>()

taskRepo.add(Task(title: "Write report", priority: .high, estimatedTime: 3))
taskRepo.add(Task(title: "Meeting notes", status: .inProgress(assignee: "Mustafa"), priority: .critical, estimatedTime: 1))
taskRepo.add(Task(title: "Update changelog", status: .done(resolvedAt: Date()), priority: .low, estimatedTime: 2))

bugRepo.add(Bug(title: "Crash on login", priority: .critical, severity: .blocker, affectedVersion: "v2.4.0"))
bugRepo.add(Bug(title: "watchOS UI overflow", status: .inProgress(assignee: "Ayse"), priority: .high, severity: .major, affectedVersion: "v2.4.1"))

print("--- Issues ---")
print("Tasks: \(taskRepo.count) · Bugs: \(bugRepo.count)")
for task in taskRepo.all { print("  \(task.summary)") }
for bug in bugRepo.all { print("  \(bug.summary)") }

print("\n--- Search ---")
if let critical = taskRepo.find(where: { $0.priority == .critical }) {
    print("First critical task: \(critical.summary)")
} else {
    print("No critical task found.")
}

print("\n--- Delete ---")
if let resolved = taskRepo.find(where: { $0.status.kind == .done }) {
    do {
        try taskRepo.delete(id: resolved.id)
        print("Deleted: \(resolved.title) · remaining: \(taskRepo.count)")
    } catch {
        print("Delete failed: \(error.localizedDescription)")
    }
}

do {
    try bugRepo.delete(id: UUID())
} catch let error as RepositoryError {
    print("Delete failed: \(error.localizedDescription)")
} catch {
    print("Unexpected: \(error)")
}

print("\n--- Sorted by priority ---")
for task in taskRepo.sortedByPriority() { print("  \(task.summary)") }
for bug in bugRepo.sortedByPriority() { print("  \(bug.summary)") }

print("\n--- Status report ---")
let taskCounts = taskRepo.countByStatus()
for kind in StatusKind.allCases {
    print("Tasks \(kind.rawValue): \(taskCounts[kind, default: 0])")
}

let bugCounts = bugRepo.countByStatus()
for kind in StatusKind.allCases {
    print("Bugs \(kind.rawValue): \(bugCounts[kind, default: 0])")
}

print("\n--- Priority report ---")
let taskPriorities = taskRepo.countByPriority()
for priority in Priority.allCases {
    print("Task \(priority): \(taskPriorities[priority, default: 0])")
}

print("\n--- Persistence ---")
let url = URL.temporaryDirectory.appending(path: "tasks.json")
do {
    try taskRepo.save(to: url)

    var loadedRepo = IssueRepository<Task>()
    try loadedRepo.load(from: url)

    print("Saved \(taskRepo.count), loaded \(loadedRepo.count)")
    print("First loaded: \(loadedRepo.all.first?.summary ?? "empty")")
    print("Ids match: \(loadedRepo.all.first?.id == taskRepo.all.first?.id)")
} catch {
    print("Persistence failed: \(error.localizedDescription)")
}
