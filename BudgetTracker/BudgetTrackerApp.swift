//
//  BudgetTrackerApp.swift
//  BudgetTracker
//
//  Created by Prashant Rai on 20/09/25.
//

import SwiftUI
import SwiftData

@main
struct BudgetTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
