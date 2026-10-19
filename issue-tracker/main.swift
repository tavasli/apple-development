import Foundation

print(Priority.high > Priority.low)

let status = Status.inProgress(assignee: "Mustafa")
print(status)

let task = Task(title: "Write report", priority: .high, estimatedTime: 3)
print(task.summary)

let bug = Bug(title: "Crash on login", priority: .critical, severity: .blocker, affectedVersion: "v2.4.1")
print(bug.summary)
