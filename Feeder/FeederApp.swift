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
        let feedSchema = Schema([Feed.self])
        let noteSchema = Schema([Note.self])
        let feedModelConfiguration = ModelConfiguration("default", schema: feedSchema, isStoredInMemoryOnly: false)
        let noteModelConfiguration = ModelConfiguration("NoteConfiguration", schema: noteSchema, isStoredInMemoryOnly: false, groupContainer: .none, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: Feed.self, Note.self, configurations: feedModelConfiguration, noteModelConfiguration)
        } catch {
            //TODO: add some error correction
            fatalError("Could not create ModelContainer: \n\(error)")
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
