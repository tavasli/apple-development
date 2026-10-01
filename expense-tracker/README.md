# Expense Tracker

A small command line expense tracker I wrote while learning Swift. No UI, it runs in the terminal.

## Build and run

    swiftc *.swift -o tracker
    ./tracker

## Commands

    add <amount> <category> <title>   Add an expense
    list                              List all expenses
    report                            Category totals with a simple bar chart
    total                             Total amount spent
    delete <position>                 Delete an expense by its position in the list
    help                              Show the command list
    quit                              Exit

Categories: food, transport, bills, entertainment, other

Amounts accept both `12.50` and `12,50`.

## Structure

    Category.swift       Expense categories
    Expense.swift        The expense model
    ExpenseStore.swift   Holds the expenses, handles add and delete
    CommandParser.swift  Turns a line of input into a command, validates it
    Reports.swift        Totals and the text report
    main.swift           Input loop

## Notes

Amounts are stored as `Decimal` rather than `Double`, so the arithmetic stays exact.
Expenses are value types and the store is a class, since it is shared and mutable.
