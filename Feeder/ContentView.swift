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
    @State private var showTodayOnly: Bool = true
    @State private var showAddItemSheet: Bool = false
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
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                    Button {
                        self.showAddItemSheet.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(showTodayOnly ? "Today" : "All") {
                        showTodayOnly.toggle()
                    }
                }
            }
            .sheet(isPresented: $showAddItemSheet) {
                AddFeedSheetView()
                    .presentationDetents([.medium])
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
