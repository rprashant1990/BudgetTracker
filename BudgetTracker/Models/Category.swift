//
//  Item.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var timestamp: Date
    @Relationship(inverse: \Expense.category)
    var expenses: [Expense] = []
    var budget: Double {
        return expenses.reduce(0) { (result, expense) in
            if expense.type == .budgetCut {
                return result - expense.amount
            } else if expense.type == .budgetAdd {
                return result + expense.amount
            }
            return result
        }
    }
    
    var balance: Double {
        return expenses.reduce(0) { (result, expense) in
            if expense.type == .budgetCut || expense.type == .debit {
                return result - expense.amount
            } else if expense.type == .budgetAdd || expense.type == .credit {
                return result + expense.amount
            }
            return result
        }
    }
    
    init(name: String, timestamp: Date = Date.now) {
        self.name = name
        self.timestamp = timestamp
    }
}


struct Utils {
    static func parsedAmount(_ amount: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        if let number = formatter.number(from: amount) {
            return number.doubleValue
        }
        return Double(amount)
    }
    
    static func formatCurrency(_ amount: Double) -> String {
        let currencyCode = Locale.current.currency?.identifier ?? "INR"
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: amount as NSNumber) ?? ""
    }
}
