//
//  ContentView.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showTodayOnly: Bool = false
    var calendar: Calendar = .autoupdatingCurrent
    var body: some View {
        NavigationSplitView {
            FeedsView(limitingDate: showTodayOnly ? calendar.startOfDay(for: .now) : .distantPast)
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(showTodayOnly ? "Today" : "All") {
                        showTodayOnly.toggle()
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), source: .formula_enriched)
            modelContext.insert(newItem)
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
