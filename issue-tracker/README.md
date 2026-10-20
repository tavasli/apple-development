# Issue Tracker

A small command line issue tracker I wrote while learning Swift generics and protocols.
No UI, it prints a fixed scenario to the terminal.

## Build and run

    swiftc *.swift -o tracker
    ./tracker

## What it does

Two issue types, `Task` and `Bug`, share a `Trackable` protocol. A single generic
repository stores either of them, so adding a third type would not require a new store.

The program prints: both lists, a search result, a successful and a failed delete,
a list sorted by priority, status and priority reports, and a JSON round trip.

## Structure

    Status.swift           Priority, Status, StatusKind and Severity
    Trackable.swift        The shared protocol and its default summary
    Task.swift             A planned piece of work
    Bug.swift              A defect, with severity and affected version
    IssueRepository.swift  Generic storage, errors, sorting, reports, persistence
    main.swift             The scenario

## Notes

`Status` carries its data in associated values, so an assignee only exists while an
issue is in progress and a resolution date only exists once it is done.

Saving to JSON lives in an extension constrained to `Codable` items, so the methods
only exist for types that can actually be encoded.

Grouping uses `StatusKind` rather than `Status`, because two issues resolved at
different times would otherwise fall into different groups.
