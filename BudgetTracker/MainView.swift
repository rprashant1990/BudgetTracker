//
//  MainView.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Category]
    @State private var isPresentingAddCategory = false

    var body: some View {
        TabView {
            NavigationStack {
                Group {
                    if items.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundStyle(.tertiary)
                            Text("No Categories Yet")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text("Tap the plus button to add your first category.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Button {
                                addItem()
                            } label: {
                                Label("Add Category", systemImage: "plus")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color(.systemGroupedBackground))
                    } else {
                        List {
                            Section(header: categoryListHeader) {
                                ForEach(items) { item in
                                    NavigationLink {
                                        CategoryExpenseView(category: item)
                                    } label: {
                                        CategoryRow(item: item)
                                            .padding(.vertical, 4)
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGroupedBackground))
                    }
                }
                .animation(.snappy, value: items.count)
                .navigationTitle("Categories")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Category", systemImage: "plus")
                                .symbolEffect(.bounce, value: isPresentingAddCategory)
                        }
                        .tint(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddCategory) {
                NavigationStack {
                    AddCategoryView(isPresentingAddCategory: $isPresentingAddCategory)
                }
            }
            .tabItem {
                Label("Categories", systemImage: "list.bullet")
            }
            .badge(items.count)
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "chart.pie")
                }
        }
    }
    
    private func addItem() {
        withAnimation {
            isPresentingAddCategory = true
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
}



private extension MainView {
    @ViewBuilder
    var categoryListHeader: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            // Name column (leading)
            Text("Category")
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)

            // Budget column (center)
            Text("Budget")
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .textCase(.uppercase)
                .foregroundStyle(Color.blue)
                .frame(width: 110, alignment: .trailing)

            // Balance column (trailing)
            Text("Balance")
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .textCase(.uppercase)
                .foregroundStyle(.green)
                .frame(width: 110, alignment: .trailing)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    MainView()
        .modelContainer(for: Category.self, inMemory: true)
}

