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
    
    @Query(sort: \Feed.timestamp, order: .forward) private var items: [Feed]
    
    var calendar: Calendar = .autoupdatingCurrent
    var limitingDate: Date {
        return self.showTodayOnly ? Calendar.autoupdatingCurrent.startOfDay(for:Date.now) : .distantPast
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                FeedsView(limitingDate: self.limitingDate, showTodayOnly: self.showTodayOnly)
#if os(macOS)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .foregroundStyle(.green)
#endif
                    .toolbar {
#if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                                .foregroundStyle(.green)
                        }
#endif
                        ToolbarItem {
                            Button {
                                self.showAddItemSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
                            }
                            .foregroundStyle(.green)
                        }
                        ToolbarItem {
                            Button {
                                showTodayOnly.toggle()
                            } label: {
                                Text(showTodayOnly ? "Show All" : "Show Today")
                            }
                        }
                        ToolbarItem {
                            Button {
                                self.deleteAllItems()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .sheet(isPresented: $showAddItemSheet) {
                        AddFeedSheetView()
                            .presentationDetents([.large])
                    }
#if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
#endif
                    .navigationTitle("Feeds")
            }
        } detail: {
            FeedDetailView()
        }
        .foregroundStyle(.green)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Feed.self, inMemory: true)
}

extension ContentView {
    
    private func deleteAllItems() {
        withAnimation {
            for index in self.items.indices {
                modelContext.delete(items[index])
            }
        }
    }
}

