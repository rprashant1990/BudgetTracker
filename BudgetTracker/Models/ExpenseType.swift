//
//  ExpenseType.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

enum ExpenseType: String, Codable, Sendable, CaseIterable {
    case debit = "Debit"
    case credit = "Credit"
    case budgetAdd = "Budget Add"
    case budgetCut = "Budget Cut"
}
