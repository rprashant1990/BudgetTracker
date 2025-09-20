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
    
    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

@Model
final class Expense {
    var amount: Double
    
    init(timestamp: Date, amount: Double) {
        self.amount = amount
    }
}


