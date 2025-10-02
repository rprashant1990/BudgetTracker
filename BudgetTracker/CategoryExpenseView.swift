//
//  CategoryView.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 02/10/25.
//

import SwiftUI
import SwiftData

struct CategoryExpenseView: View {
    let category: Category
    @State private var isPresentingAddExpense = false
    var body: some View {
        List {
            if category.expenses.isEmpty {
                ContentUnavailableView("No expenses", systemImage: "list.bullet.rectangle", description: Text("Add an expense to see it here."))
            } else {
                ForEach(category.expenses.sorted(by: { $0.timestamp > $1.timestamp }), id: \.persistentModelID) { expense in
                    NavigationLink(destination: ExpenseView(expenseToEdit: expense)) {
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text((expense.note?.isEmpty == false ? expense.note! : expense.type.rawValue))
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Text(expense.timestamp, format: .dateTime.year().month().day())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(Utils.formatCurrency(expense.amount))
                                .amountStyle(for: expense.type)
                                .padding(.vertical)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isPresentingAddExpense = true }) {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingAddExpense) {
            NavigationStack {
                ExpenseView(expenseToEdit: nil, initialCategoryID: category.id)
            }
        }
    }
}

#Preview {
    let category = Category(name: "Test")
    category.expenses.append(Expense(category: category, amount: 49.99, type: .debit, timestamp: .now.addingTimeInterval(-86400), note: "Groceries"))
    category.expenses.append(Expense(category: category, amount: 1200, type: .credit, timestamp: .now.addingTimeInterval(-3600), note: "Refund"))
    return NavigationStack { CategoryExpenseView(category: category) }
        .modelContainer(for: [Category.self, Expense.self], inMemory: true)
}

