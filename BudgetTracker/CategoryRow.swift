//
//  CategoryRow.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

import SwiftUI

struct CategoryRow: View {
    let item: Category
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            // Name column (leading) with icon
            HStack(spacing: 8) {
                Image(systemName: "indianrupeesign.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.tint, .quaternary)
                    .font(.title3)
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)
            
            // Budget column (center)
            Text(Utils.formatCurrency(item.budget))
                .monospacedDigit()
                .amountStyle(for: .budgetAdd)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .allowsTightening(true)
                .frame(minWidth: 72, idealWidth: 110, maxWidth: 140, alignment: .trailing)
            
            Text(Utils.formatCurrency(item.balance))
                .monospacedDigit()
                .amountStyle(for: item.balance)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .allowsTightening(true)
                .frame(minWidth: 72, idealWidth: 110, maxWidth: 140, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let categoty = Category(name: "Test Category")
    categoty.expenses.append(Expense(category: categoty, amount: 1000, type: .budgetAdd))
    categoty.expenses.append(Expense(category: categoty, amount: 4000, type: .debit))
    return CategoryRow(item: categoty)
}
