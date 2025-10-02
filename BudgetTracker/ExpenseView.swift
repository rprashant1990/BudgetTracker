//
//  ExpenseView.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 02/10/25.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    @State private var amountText: String = ""
    @State private var selectedType: ExpenseType = .debit
    @Query private var categories: [Category]
    @State private var selectedCategoryID: Category.ID? = nil
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var expenseToEdit: Expense? = nil
    var initialCategoryID: Category.ID? = nil

    var body: some View {
        Form {
            Section("Amount") {
                TextField("Enter amount", text: $amountText)
                    .keyboardType(.decimalPad)
            }
            Section("Category") {
                Picker("Category Type", selection: $selectedCategoryID) {
                    ForEach(categories) { category in
                        Text(category.name).tag(category.id as Category.ID?)
                    }
                }
                .pickerStyle(.menu)
                Picker("Expense Type", selection: $selectedType) {
                    ForEach(ExpenseType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .onAppear {
            if let e = expenseToEdit {
                // Pre-fill fields for editing
                if amountText.isEmpty {
                    amountText = String(e.amount)
                }
                selectedType = e.type
                selectedCategoryID = e.category?.persistentModelID
            } else {
                if selectedCategoryID == nil {
                    selectedCategoryID = initialCategoryID ?? categories.first?.id
                }
            }
        }
        .navigationTitle(expenseToEdit == nil ? "Add" : "Edit")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    saveExpense()
                }
                .disabled(!canSave)
            }
        }
    }

    private var canSave: Bool {
        Utils.parsedAmount(amountText) != nil && selectedCategoryID != nil
    }

    private func saveExpense() {
        guard
            let categoryID = selectedCategoryID,
            let category = categories.first(where: { $0.id == categoryID }),
            let amount = Utils.parsedAmount(amountText)
        else {
            return
        }

        if let expense = expenseToEdit {
            // Update existing expense
            expense.amount = amount
            expense.type = selectedType
            expense.category = category
            do {
                try modelContext.save()
            } catch {
                // Handle save error if needed
            }
            dismiss()
        } else {
            // Add new expense
            let expense = Expense(category: category, amount: amount, type: selectedType)
            expense.category = category
            modelContext.insert(expense)
            do {
                try modelContext.save()
            } catch {
                // Handle save error if needed
            }
            dismiss()
        }
    }
}

#Preview {
    ExpenseView()
        .modelContainer(for: [Category.self, Expense.self], inMemory: true)
}
