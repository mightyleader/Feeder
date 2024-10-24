//
//  FeederApp.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import SwiftUI
import SwiftData

@main
struct FeederApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Feed.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            //TODO: add some error correction
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .foregroundStyle(.green)
        }
        .modelContainer(sharedModelContainer)
    }
}
