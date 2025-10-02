//
//  File.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 02/10/25.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newCategoryName: String = ""
    @State private var newCategoryBudget: String = ""
    @Binding var isPresentingAddCategory: Bool
    
    var body: some View {
        Form {
            Section(header: Text("New Category")) {
                TextField("Category name", text: $newCategoryName)
                TextField("Budget", text: $newCategoryBudget)
            }
        }
        .navigationTitle("Add Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    newCategoryName = ""
                    isPresentingAddCategory = false
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveNewCategory()
                }
                .disabled(!canSave)
            }
        }
    }
    
    private var canSave: Bool {
        Utils.parsedAmount(newCategoryBudget) != nil && !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNewCategory() {
        let trimmed = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            let newItem = Category(name: trimmed, timestamp: Date())
            modelContext.insert(newItem)
            newCategoryName = ""
            let budget = Utils.parsedAmount(newCategoryBudget)!
            let newExpense = Expense(category: newItem, amount: budget, type: .budgetAdd)
            newItem.expenses.append(newExpense)
            isPresentingAddCategory = false
        }
    }
}

#Preview {
    AddCategoryView(isPresentingAddCategory: .constant(true))
        .modelContainer(for: Category.self, inMemory: true)
}
