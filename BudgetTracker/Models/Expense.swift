//
//  Expense.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

import Foundation
import SwiftData

@Model
final class Expense {
    @Relationship var category: Category?
    var timestamp: Date
    var type: ExpenseType
    var amount: Double
    var note: String?
    
    init(category: Category, amount: Double, type: ExpenseType,  timestamp: Date = Date.now, note: String? = nil) {
        self.category = category
        self.amount = amount
        self.type = type
        self.note = note
        self.timestamp = timestamp
    }
    
    convenience init(category: Category, amount: Double, type: ExpenseType) {
        self.init(category: category, amount: amount, type: type, note: nil)
    }
}
